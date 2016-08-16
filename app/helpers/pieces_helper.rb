module PiecesHelper
  def display_piece(piece, css_class)
    data = piece_path(piece)
    case piece.type
    when 'King'
      css_class += ' ' + piece.color + '-king'
    when 'Queen'
      css_class += ' ' + piece.color + '-queen'
    when 'Rook'
      css_class += ' ' + piece.color + '-rook'
    when 'Bishop'
      css_class += ' ' + piece.color + '-bishop'
    when 'Knight'
      css_class += ' ' + piece.color + '-knight'
    when 'Pawn'
      css_class += ' ' + piece.color + '-pawn'
    end
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
