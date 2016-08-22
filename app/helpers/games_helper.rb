module GamesHelper
  def render_piece(row, col)
    piece = @game.piece_at_location(row, col)

    return '' unless piece.present?
    display_piece(piece, 'piece-font')
  end
end
