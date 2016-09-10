class StaticPagesController < ApplicationController
  def index
    @available_games = Game.available
  end

  def about
  end
end
