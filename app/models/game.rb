class Game < ActiveRecord::Base
  validates :name, presence: true
  has_many :pieces
  belongs_to :black_player, class_name: 'User'
  belongs_to :white_player, class_name: 'User'
end
