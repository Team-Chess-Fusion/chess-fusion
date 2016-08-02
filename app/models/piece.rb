class Piece < ActiveRecord::Base
  belongs_to :game

  def obstructed?
  end
end
