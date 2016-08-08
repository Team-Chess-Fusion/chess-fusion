module PiecesHelper
  def render_piece_after_selection(row, col)
    piece = @game.piece_at_location(row, col)

    return content_tag :div, class: 'empty-square' do
      link_to piece_path(@selected_piece, piece: { row_coordinate: row, column_coordinate: col }), method: :patch do
        ''
      end
    end unless piece.present?

    return link_to game_piece_path(game_id: @game, id: piece) do
      piece.color.capitalize! + ' ' + piece.type
    end unless piece == @selected_piece

    content_tag :div, class: 'selected-piece' do
      piece.color.capitalize! + ' ' + piece.type
    end
  end
end
