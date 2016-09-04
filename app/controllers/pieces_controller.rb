class PiecesController < ApplicationController
  before_action :authenticate_user!
  def update
    @piece = Piece.find(params[:id])
    # return render json: { update_attempt: 'invalid move' } unless check_player_move(@piece)

    check_player_move(@piece)

    origin_row = @piece.row_coordinate
    origin_col = @piece.column_coordinate

    move_result = check_move_validity(@piece)

    in_check = @piece.game.in_check?.present?
    checkmate = @piece.game.checkmate?
    game_winner = @piece.color
    stalemate = @piece.game.stalemate?(@piece.color)
    pawn_to_promote = pawn_promotion(@piece)
    en_passant_status = @piece.change_enpassant_status

    Pusher.trigger(@piece.game.web_socket_channel, move_result,
                   current_user: current_user.id,
                   color_moved: @piece.color,
                   origin_square: { row: origin_row,
                                    col: origin_col },
                   destination_square: { row: @piece.row_coordinate,
                                         col: @piece.column_coordinate },
                   stalemate: stalemate,
                   in_check: in_check,
                   checkmate: checkmate,
                   game_winner: game_winner,
                   en_passant_status: en_passant_status)

    render json: { update_attempt: move_result, in_check: in_check, stalemate: stalemate, checkmate: checkmate,
                   game_winner: game_winner, promote_pawn: pawn_to_promote, move_color: @piece.game.current_move_color,
                   en_passant_status: en_passant_status }
  end

  def promote_pawn
    pawn = Piece.find(params[:piece_id])
    old_piece = pawn.color + '_' + pawn.type.downcase
    new_piece = pawn.game.pieces.create(pawn_promotion_params.merge(color: pawn.color, row_coordinate: pawn.row_coordinate, column_coordinate: pawn.column_coordinate, has_moved?: true))
    pawn.destroy
    game_channel = 'game_channel-' + new_piece.game.id.to_s
    Pusher.trigger(game_channel, 'promote_pawn', message: 'hello world')
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
    return render json: { update_attempt: 'invalid move' } unless piece.valid_move?(params[:piece][:row_coordinate].to_i, params[:piece][:column_coordinate].to_i)

    move_result = piece.move_to!(params[:piece][:row_coordinate].to_i, params[:piece][:column_coordinate].to_i)
    return render json: { update_attempt: 'invalid move' } if move_result == 'invalid'

    move_result
  end

  def check_player_move(piece)
    if piece.color == 'white'
      return render json: { update_attempt: 'invalid move' } unless current_user.id == piece.game.white_player_id
    else
      return render json: { update_attempt: 'invalid move' } unless current_user.id == piece.game.black_player_id
    end
    true
  end
end
