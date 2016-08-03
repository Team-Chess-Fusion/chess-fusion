class StaticPagesController < ApplicationController
  def index
    @available_games = Game.available
  end
end
