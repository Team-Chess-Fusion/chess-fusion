class Game < ActiveRecord::Base
  validates :name, presence: true
  scope :available, -> { where('white_player_id IS NULL OR black_player_id IS NULL') }

  has_many :pieces
  belongs_to :black_player, class_name: 'User'
  belongs_to :white_player, class_name: 'User'

  after_create :populate_board!

  def populate_board!
    [0, 1, 6, 7].each do |row|
      color = row < 1 ? 'white' : 'black'

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
end
