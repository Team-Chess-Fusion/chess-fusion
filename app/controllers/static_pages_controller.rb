class StaticPagesController < ApplicationController
  def index
    @available_games = Game.available
    @user = current_user if user_signed_in?
  end
end
