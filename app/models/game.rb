class Game < ActiveRecord::Base
  validates :name, presence: true
  scope :available, -> { where("white_player_id IS NULL OR black_player_id IS NULL") }  

  has_many :pieces
  belongs_to :black_player, :class_name => 'User'
  belongs_to :white_player, :class_name => 'User'
end
