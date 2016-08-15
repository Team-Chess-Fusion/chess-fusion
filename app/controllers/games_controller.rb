class GamesController < ApplicationController
  before_action :authenticate_user!, only: [:update]
  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params)
    redirect_to root_path if @game.valid?
  end

  def show
    @game = Game.find(params[:id])
  end

  def index
    @games = Game.all
  end

  def update
    @game = Game.find(params[:id])

    return render_not_found(:unauthorized) if @game.white_player_id.present? && @game.black_player_id.present?

    if @game.white_player_id.present?
      @game.update_attributes(black_player_id: current_user.id)
    else
      @game.update_attributes(white_player_id: current_user.id)
    end
    redirect_to root_path
  end

  def forfeit
    game = Game.find(params[:id])
    return render_not_found(:unauthorized) if @game.white_player_id.present? && @game.black_player_id.present?
    game.forfeit!(current_user)
    redirect_to game
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end
end
