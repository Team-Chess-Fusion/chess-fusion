class Piece < ActiveRecord::Base
  belongs_to :game

  def obstructed?(destination_x, destination_y)
    puts "this piece is #{self.type}"
    @game = Game.find(self.game_id)
    puts "game  is #{game.inspect}"
    #@game = Game.find(self.piece.game_id)
    #@piece = self.piece
    #puts "game is #{@game.inspect}"
  end
end
