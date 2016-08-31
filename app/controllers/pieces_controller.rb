class PiecesController < ApplicationController
  before_action :authenticate_user!
  def update
    @piece = Piece.find(params[:id])
    move_result = check_move_validity(@piece)
    return render json: { update_attempt: 'invalid move' } unless move_result

    in_check = @piece.game.in_check?.present?
    stalemate = @piece.game.stalemate?(@piece.color)
    pawn_to_promote = pawn_promotion(@piece)

    Pusher.trigger('game_channel', 'opponent_moved', {
      message: 'hello world',
      color_moved: @piece.color
    })

    render json: { update_attempt: move_result, in_check: in_check, stalemate: stalemate, promote_pawn: pawn_to_promote, move_color: @piece.game.current_move_color }
  end

  def promote_pawn
    pawn = Piece.find(params[:piece_id])
    old_piece = pawn.color + '_' + pawn.type.downcase
    new_piece = pawn.game.pieces.create(pawn_promotion_params.merge(color: pawn.color, row_coordinate: pawn.row_coordinate, column_coordinate: pawn.column_coordinate, has_moved?: true))
    pawn.destroy
    render json: { promotion_attempt: 'success', promoted_to: new_piece.type, color: new_piece.color, id: new_piece.id, old_piece: old_piece, row: new_piece.row_coordinate, col: new_piece.column_coordinate }
  end

  private

  def piece_params
    params.require(:piece).permit(:row_coordinate, :column_coordinate)
  end

  def pawn_promotion_params
    params.require(:piece).permit(:type)
  end

  def pawn_promotion(piece)
    return nil unless piece.is_a? Pawn
    last_row = piece.color == 'white' ? 7 : 0
    return piece.id if piece.row_coordinate == last_row
    nil
  end

  def check_move_validity(piece)
    return false unless piece.valid_move?(params[:piece][:row_coordinate].to_i, params[:piece][:column_coordinate].to_i)

    move_result = piece.move_to!(params[:piece][:row_coordinate].to_i, params[:piece][:column_coordinate].to_i)
    return false if move_result == 'invalid'

    move_result
  end
end
