class Game < ActiveRecord::Base
  validates :name, presence: true
  scope :available, -> { where('white_player_id IS NULL OR black_player_id IS NULL') }

  has_many :pieces
  belongs_to :black_player, class_name: 'User'
  belongs_to :white_player, class_name: 'User'

  def self.create_and_populate_board!(params)
    new_game = create(params)
    new_game.populate_board!
    new_game
  end

  def in_check?
    %w(white black).each do |king_color|
      king = pieces.find_by(type: 'King', color: king_color)

      enemy_color = %w(white black).select { |color| king_color != color }

      return king if location_is_under_attack_by_color?(enemy_color, king.row_coordinate, king.column_coordinate)
    end

    nil
  end

  def checkmate?
    king = in_check?
    return false if king.nil?

    # scan entire board to collect required data
    data_lists = build_attackers_and_friendly_lists(king)
    king_moves_list, attackers, friendly_list = data_lists

    # puts "attackers list #{attackers.inspect}"
    # puts "friendly list is #{friendly_list.inspect}"
    # puts "king moves list is #{king_moves_list}"

    return false if king_can_move_out_of_check?(king, king_moves_list)

    return true if attackers.count > 1

    # determine if attacker can be captured
    return false if king_attacker_can_be_captured?(attackers.first, friendly_list)

    # determine if check can be blocked
    return false if check_can_be_blocked?(king, attackers.first, friendly_list)

    true
  end

  def populate_board!
    [0, 1, 6, 7].each do |row|
      color = row <= 1 ? 'white' : 'black'

      (0..7).each do |column|
        if row == 1 || row == 6
          type = 'Pawn'
        else
          case column
          when 0, 7
            type = 'Rook'
          when 1, 6
            type = 'Knight'
          when 2, 5
            type = 'Bishop'
          when 4
            type = 'King'
          else
            type = 'Queen'
          end
        end
        pieces.create(type: type, color: color, row_coordinate: row, column_coordinate: column)
      end
    end
  end

  def piece_at_location(row, col)
    pieces.find_by('row_coordinate = ? AND column_coordinate = ?', row, col)
  end

  def location_is_under_attack_by_color?(color, row, col)
    pieces.where('color = ?', color).find_each do |enemy|
      return true if enemy.valid_move?(row, col)
    end

    false
  end

  private

  def build_attackers_and_friendly_lists(king)
    king_moves_list = []
    attackers = []
    friendly_list = []
    output_list = [king_moves_list, attackers, friendly_list]

    (0..7).each do |col|
      (0..7).each do |row|
        next if row == king.row_coordinate && col == king.column_coordinate
        king_moves_list << [row, col] if king.valid_move?(row, col)
        other_piece = piece_at_location(row, col)
        # puts "other piece is #{other_piece.inspect}"

        next if other_piece.nil?
        if other_piece.color == king.color
          friendly_list << other_piece
        elsif other_piece.valid_move?(king.row_coordinate, king.column_coordinate)
          attackers << other_piece
        end
      end
    end
    output_list
  end

  def king_can_move_out_of_check?(king, king_moves_list)
    opposite_color = %w(white black).select { |color| king.color != color }
    save_row = king.row_coordinate
    save_column = king.column_coordinate
    king.update_attributes(row_coordinate: nil, column_coordinate: nil)

    king_moves_list.each do |move|
      row, col = move
      unless location_is_under_attack_by_color?(opposite_color, row, col)
        king.update_attributes(row_coordinate: save_row, column_coordinate: save_column)
        return true
      end
    end
    king.update_attributes(row_coordinate: save_row, column_coordinate: save_column)
    false
  end

  def king_attacker_can_be_captured?(single_attacker, friendly_list)
    friendly_list.each do |friendly|
      return true if friendly.valid_move?(single_attacker.row_coordinate, single_attacker.column_coordinate)
    end
    false
  end

  def check_can_be_blocked?(king, single_attacker, friendly_list)
    if king.row_coordinate == attacker.row_coordinate
      return true if attacker_can_be_blocked_horizontally?(king, single_attacker, friendly_list)
    elsif king.column_coordinate == attacker.column_coordinate
      return true if attacker_can_be_blocked_vertically?(king, single_attacker, friendly_list)
    elsif (king.column_coordinate - attacker.column_coordinate).abs == (king.row_coordinate - attacker.row_coordinate).abs
      return true if attacker_can_be_blocked_diagonally?(king, single_attacker, friendly_list)
    end
    false
  end

  def attacker_can_be_blocked_horizontally?(king, single_attacker, friendly_list)
    start = [single_attacker.column_coordinate, king.column_coordinate].min + 1
    finish = [single_attacker.column_coordinate, king.column_coordinate].max - 1

    while start <= finish
      friendly_list.each do |friendly|
        return true if friendly.valid_move?(king.row_coordinate, start)
      end
      start += 1
    end
    false
  end

  def attacker_can_be_blocked_vertically?(king, single_attacker, friendly_list)
    start = [single_attacker.row_coordinate, king.row_coordinate].min + 1
    finish = [single_attacker.row_coordinate, king.row_coordinate].max - 1

    while start <= finish
      friendly_list.each do |friendly|
        return true if friendly.valid_move?(start, king.column_coordinate)
      end
      start += 1
    end
    false
  end

  def attacker_can_be_blocked_diagonally?(king, single_attacker, friendly_list)
    slope = (king.column_coordinate - single_attacker.column_coordinate) / (king.row_coordinate - single_attacker.row_coordinate)
    start_x = [king.row_coordinate, single_attacker.row_coordinate].min + 1
    if slope > 0
      start_y_increment = 1
      start_y = [king.column_coordinate, single_attacker.column_coordinate].min + start_y_increment
    else
      start_y_increment = -1
      start_y = [king.column_coordinate, single_attacker.column_coordinate].max + start_y_increment
    end
    end_x = [king.row_coordinate, single_attacker.row_coordinate].max - 1

    while start_x <= end_x
      friendly_list.each do |friendly|
        return true if friendly.valid_move?(start_x, start_y)
      end
      start_x += 1
      start_y += start_y_increment
    end
    false
  end
end
