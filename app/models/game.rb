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

      enemy_color =  %w(white black).select { |color| king_color != color }

      return king if location_is_under_attack_by_color?(enemy_color, king.row_coordinate, king.column_coordinate)
    end

    nil
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
end
