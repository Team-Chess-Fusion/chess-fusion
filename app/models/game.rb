class Game < ActiveRecord::Base
  validates :name, presence: true
  scope :available, -> { where("white_player_id IS NULL OR black_player_id IS NULL") }  
end
