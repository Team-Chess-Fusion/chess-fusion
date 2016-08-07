class PiecesController < ApplicationController
  def show
    @game = Game.find_by_id(params[:game_id])
    @selected_piece = Piece.find_by_id(params[:id])
  end
end
