class PiecesController < ApplicationController
  before_action :authenticate_user!
  def update
    @piece = Piece.find(params[:id])

    origin_square = { row: @piece.row_coordinate, col: @piece.column_coordinate }

    in_check = @piece.game.in_check?.present?
    checkmate = @piece.game.checkmate?
    color_moved = @piece.color
    stalemate = @piece.game.stalemate?(@piece.color)
    pawn_to_promote = pawn_promotion(@piece)

    move_result = check_player_move(@piece) ? check_move_validity(@piece) : check_player_move(@piece)

    Pusher.trigger(@piece.game.web_socket_channel, move_result,
                   current_user: current_user.id,
                   color_moved: color_moved,
                   origin_square: origin_square,
                   destination_square: { row: @piece.row_coordinate,
                                         col: @piece.column_coordinate },
                   stalemate: stalemate,
                   in_check: in_check,
                   checkmate: checkmate,
                   game_winner: color_moved)

    render json: { update_attempt: move_result, in_check: in_check, stalemate: stalemate, checkmate: checkmate,
                   game_winner: color_moved, promote_pawn: pawn_to_promote, move_color: @piece.game.current_move_color }
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
    return 'invalid move' unless piece.valid_move?(params[:piece][:row_coordinate].to_i, params[:piece][:column_coordinate].to_i)

    piece.move_to!(params[:piece][:row_coordinate].to_i, params[:piece][:column_coordinate].to_i)
  end

  def check_player_move(piece)
    if piece.color == 'white'
      return 'invalid move' unless current_user.id == piece.game.white_player_id
    else
      return 'invalid move' unless current_user.id == piece.game.black_player_id
    end
    true
  end
end
