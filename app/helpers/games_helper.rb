module GamesHelper
  def render_piece(row, col)
    piece = @game.piece_at_location(row, col)

    return '' unless piece.present?
    link_to game_piece_path(game_id: @game, id: @game.piece_at_location(row, col)) do
      if piece.color == 'white'
        case piece.type
        when 'King'
          content_tag(:div, '&#9812'.html_safe, class: 'piece-font')
        when 'Queen'
          content_tag(:div, '&#9813'.html_safe, class: 'piece-font')
        when 'Rook'
          content_tag(:div, '&#9814'.html_safe, class: 'piece-font')
        when 'Bishop'
          content_tag(:div, '&#9815'.html_safe, class: 'piece-font')
        when 'Knight'
          content_tag(:div, '&#9816'.html_safe, class: 'piece-font')
        when 'Pawn'
          content_tag(:div, '&#9817'.html_safe, class: 'piece-font')
        end
      else
        case piece.type
        when 'King'
          content_tag(:div, '&#9818'.html_safe, class: 'piece-font')
        when 'Queen'
          content_tag(:div, '&#9819'.html_safe, class: 'piece-font')
        when 'Rook'
          content_tag(:div, '&#9820'.html_safe, class: 'piece-font')
        when 'Bishop'
          content_tag(:div, '&#9821'.html_safe, class: 'piece-font')
        when 'Knight'
          content_tag(:div, '&#9822'.html_safe, class: 'piece-font')
        when 'Pawn'
          content_tag(:div, '&#9823'.html_safe, class: 'piece-font')
        end
      end
    end
  end
end
