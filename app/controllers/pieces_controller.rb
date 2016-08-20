class PiecesController < ApplicationController
  before_action :authenticate_user!
  def update
    @piece = Piece.find(params[:id])
    return render json: { update_attempt: 'invalid move' } unless @piece.valid_move?(params[:piece][:row_coordinate].to_i, params[:piece][:column_coordinate].to_i)
    @piece.update_attributes(piece_params)
    in_check = @piece.game.in_check?.present?

    render json: { update_attempt: 'success', in_check: in_check }
  end

  private

  def piece_params
    params.require(:piece).permit(:row_coordinate, :column_coordinate)
  end
end
