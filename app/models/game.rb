class Game < ActiveRecord::Base
  validates :name, presence: true
  scope :available, -> { where('white_player_id IS NULL OR black_player_id IS NULL') }

  has_many :pieces
  belongs_to :black_player, class_name: 'User'
  belongs_to :white_player, class_name: 'User'
  belongs_to :winner, class_name: 'User'

  def web_socket_channel
    "game_channel-#{id}"
  end

  def self.create_and_populate_board!(params)
    new_game = create(params)

    Game::BoardPopulator.new(new_game).run
  end

  def stalemate?(color)
    stalemate = true
    enemy_color = opposite_color(color)
    king = pieces.find_by(type: 'King', color: color)

    king_moves_list, _attackers, friendly_list = build_attackers_and_friendly_lists(king)
    stalemate = false if king_moves_list.empty?

    king_moves_list.each do |row, col|
      stalemate = false unless location_is_under_attack_by_color?(enemy_color, row, col)
    end

    # if the king is the only one left, no need to check if there are blockers
    unless friendly_list.empty?
      stalemate = false unless find_blockers(friendly_list, king).count == friendly_list.count
    end

    stalemate
  end

  def in_check?
    %w(white black).each do |king_color|
      king = pieces.find_by(type: 'King', color: king_color)

      return king if location_is_under_attack_by_color?(opposite_color(king_color), king.row_coordinate, king.column_coordinate)
    end

    nil
  end

  def checkmate?
    king = in_check?
    return false if king.nil?

    # scan entire board to collect required data
    king_moves_list, attackers, friendly_list = build_attackers_and_friendly_lists(king)

    return false if king_can_move_out_of_check?(king, king_moves_list)

    return true if attackers.count > 1

    return false if king_attacker_can_be_captured?(king, attackers.first, friendly_list)

    # determine if check can be blocked
    return false if check_can_be_blocked?(king, attackers.first, friendly_list)

    self.winner_id = white_player_id if king.color == 'black'
    self.winner_id = black_player_id if king.color == 'white'

    true
  end

  def piece_at_location(row, col)
    pieces.find_by('row_coordinate = ? AND column_coordinate = ?', row, col)
  end

  def location_is_under_attack_by_color?(color, row, col)
    pieces.where('color = ?', color).find_each do |enemy|
      unless enemy.row_coordinate.nil? || (enemy.row_coordinate == row && enemy.column_coordinate == col)
        return true if enemy.valid_move?(row, col)
      end
    end

    false
  end

  def forfeiting_user(user)
    players = [black_player, white_player]
    self.winner = players.find { |player| player.id != user.id }
    self.forfeit_id = players.find { |player| player.id == user.id }
    self.forfeit = true
    self.active = false
    save
  end

  def opposite_color(color)
    color == 'white' ? 'black' : 'white'
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
        king_moves_list << [row, col] if king.valid_move?(row, col) && piece_at_location(row, col).nil?

        other_piece = piece_at_location(row, col)
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
    opposite_color = opposite_color(king.color)
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

  def king_attacker_can_be_captured?(king, single_attacker, friendly_list)
    opposite_color = opposite_color(king.color)
    return true if king.valid_move?(single_attacker.row_coordinate, single_attacker.column_coordinate) &&
                   !location_is_under_attack_by_color?(opposite_color, single_attacker.row_coordinate, single_attacker.column_coordinate)

    friendly_list.each do |friendly|
      return true if friendly.valid_move?(single_attacker.row_coordinate, single_attacker.column_coordinate)
    end
    false
  end

  def check_can_be_blocked?(king, single_attacker, friendly_list)
    if king.row_coordinate == single_attacker.row_coordinate
      return true if attacker_can_be_blocked_horizontally?(king, single_attacker, friendly_list)
    elsif king.column_coordinate == single_attacker.column_coordinate
      return true if attacker_can_be_blocked_vertically?(king, single_attacker, friendly_list)
    elsif (king.column_coordinate - single_attacker.column_coordinate).abs ==
          (king.row_coordinate - single_attacker.row_coordinate).abs
      return true if attacker_can_be_blocked_diagonally?(king, single_attacker, friendly_list)
    end
    false
  end

  def find_blockers(friendly_list, king)
    blockers = []
    friendly_list.each do |friendly_piece|
      next if friendly_piece == king
      row = friendly_piece.row_coordinate
      col = friendly_piece.column_coordinate

      friendly_piece.update_attributes(row_coordinate: nil, column_coordinate: nil)
      blockers << friendly_piece if in_check? == king
      friendly_piece.update_attributes(row_coordinate: row, column_coordinate: col)
    end
    blockers
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
    start_y_increment = slope > 0 ? 1 : -1
    start_y = slope > 0 ? [king.column_coordinate, single_attacker.column_coordinate].min + start_y_increment : [king.column_coordinate, single_attacker.column_coordinate].max + start_y_increment
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
