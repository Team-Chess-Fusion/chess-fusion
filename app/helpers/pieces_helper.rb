module PiecesHelper
  def display_piece(piece, css_class = 'piece-font')
    if piece.color == 'white'
      case piece.type
      when 'King'
        content_tag(:p, '&#9812'.html_safe, class: css_class)
      when 'Queen'
        content_tag(:p, '&#9813'.html_safe, class: css_class)
      when 'Rook'
        content_tag(:p, '&#9814'.html_safe, class: css_class)
      when 'Bishop'
        content_tag(:p, '&#9815'.html_safe, class: css_class)
      when 'Knight'
        content_tag(:p, '&#9816'.html_safe, class: css_class)
      when 'Pawn'
        content_tag(:p, '&#9817'.html_safe, class: css_class)
      end
    else
      case piece.type
      when 'King'
        content_tag(:p, '&#9818'.html_safe, class: css_class)
      when 'Queen'
        content_tag(:p, '&#9819'.html_safe, class: css_class)
      when 'Rook'
        content_tag(:p, '&#9820'.html_safe, class: css_class)
      when 'Bishop'
        content_tag(:p, '&#9821'.html_safe, class: css_class)
      when 'Knight'
        content_tag(:p, '&#9822'.html_safe, class: css_class)
      when 'Pawn'
        content_tag(:p, '&#9823'.html_safe, class: css_class)
      end
    end
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
