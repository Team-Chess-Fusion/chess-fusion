class Game::BoardPopulator
  attr_accessor :game

  def initialize(game)
    @game = game
  end

  def run
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
        game.pieces.create(type: type, color: color, row_coordinate: row, column_coordinate: column)
      end
    end
    game
  end
end
