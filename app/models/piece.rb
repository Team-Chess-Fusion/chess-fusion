class Piece < ActiveRecord::Base
  belongs_to :game

  def obstructed?(destination_x, destination_y)
  
  end
end
