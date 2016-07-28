class Game < ActiveRecord::Base
  validates :name, presence: true
  has_many :pieces
  belongs_to :user
end
