class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  has_many :white_player_games, class_name: 'Game', foreign_key: 'white_player_id'
  has_many :black_player_games, class_name: 'Game', foreign_key: 'black_player_id'

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  def games
    Game.where('white_player_id = ? OR black_player_id = ?', id, id)
  end
end
