class Game < ActiveRecord::Base
  validates :name, presence: true
  scope :available, -> { where('white_player_id IS NULL OR black_player_id IS NULL') }

  has_many :pieces
  belongs_to :black_player, class_name: 'User'
  belongs_to :white_player, class_name: 'User'

  after_create :populate_board!

  def populate_board!
    [0, 1, 6, 7].each do |i|
      color = if i.zero?
                'white'
              else
                'black'
              end

      (0..7).each do |j|
        if i.zero?
          pieces.create(type: 'Rook', color: color, row_coordinate: i, column_coordinate: j) if j.zero? || j == 7
          pieces.create(type: 'Knight', color: color, row_coordinate: i, column_coordinate: j) if j == 1 || j == 6
          pieces.create(type: 'Bishop', color: color, row_coordinate: i, column_coordinate: j) if j == 2 || j == 5
          pieces.create(type: 'Queen', color: color, row_coordinate: i, column_coordinate: j) if j == 3
          pieces.create(type: 'King', color: color, row_coordinate: i, column_coordinate: j) if j == 4
        else
          pieces.create(type: 'Pawn', color: color, row_coordinate: i, column_coordinate: j)
        end
      end
    end
  end
end
