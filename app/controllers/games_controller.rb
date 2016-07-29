class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params)
    if @game.valid?
      redirect_to_root_path
    end
  end

  def show
    
  end

  def index
    @games = Game.all
  end


  private

  def game_params
    params.require(:game).permit(:name)
  end

end
