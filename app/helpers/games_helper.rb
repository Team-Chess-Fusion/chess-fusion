module GamesHelper
  def render_piece(row, col)
    piece = @game.piece_at_location(row, col)

    return '' unless piece.present?
    link_to game_piece_path(game_id: @game, id: @game.piece_at_location(row, col)) do
      piece.color.capitalize! + ' ' + piece.type
    end
  end
end
