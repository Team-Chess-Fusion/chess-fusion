class Game < ActiveRecord::Base
  validates :name, presence: true
  scope :available, -> {where(white_player_id == nil || black_player_id == nil)}
  
end
