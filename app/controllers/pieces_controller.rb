class PiecesController < ApplicationController
  before_action :authenticate_user!
  def update
    @piece = Piece.find(params[:id])
    @piece.update_attributes(piece_params)
    redirect_to game_path(@piece.game)
  end

  private

  def piece_params
    params.require(:piece).permit(:row_coordinate, :column_coordinate)
  end
end
