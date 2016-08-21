module PiecesHelper
  def display_piece(piece, css_class)
    data = piece_path(piece)
    css_class += ' ' + piece.color + '-' + piece.type.downcase!
    content_tag(:p, '', class: css_class, data: { update_url: data })
  end

  def render_piece_after_selection(row, col)
    piece = @game.piece_at_location(row, col)

    return content_tag :div, class: 'empty-square' do
      link_to piece_path(@selected_piece, piece: { row_coordinate: row, column_coordinate: col }), method: :patch do
        ''
      end
    end unless piece.present?

    return link_to game_piece_path(game_id: @game, id: piece) do
      display_piece(piece, 'piece-font')
    end unless piece == @selected_piece

    display_piece(piece, 'selected-piece')
  end
end
