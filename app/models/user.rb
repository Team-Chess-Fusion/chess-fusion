class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  has_many :white_player_games, class_name: 'Game', foreign_key: 'white_player_id'
  has_many :black_player_games, class_name: 'Game', foreign_key: 'black_player_id'

  def games
    Game.where('white_player_id = ? OR black_player_id = ?', id, id)
  end
end
