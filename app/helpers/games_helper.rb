module GamesHelper
  def render_piece(row, col)
    piece = @game.piece_at_location(row, col)

    return '' unless piece.present?
    link_to game_piece_path(game_id: @game, id: @game.piece_at_location(row, col)) do
      if piece.color == 'white'
        case piece.type
        when 'King'
          content_tag(:div, '&#9812', class: 'piece-font', escape: false)
        when 'Queen'
          content_tag(:div, '&#9813', class: 'piece-font', escape: false)
        when 'Rook'
          content_tag(:div, '&#9814', class: 'piece-font', escape: false)
        when 'Bishop'
          content_tag(:div, '&#9815', class: 'piece-font', escape: false)
        when 'Knight'
          content_tag(:div, '&#9816', class: 'piece-font', escape: false)
        when 'Pawn'
          content_tag(:div, '&#9817', class: 'piece-font', escape: false)
        end
      else
        case piece.type
        when 'King'
          content_tag(:div, '&#9818', class: 'piece-font', escape: false)
        when 'Queen'
          content_tag(:div, '&#9819', class: 'piece-font', escape: false)
        when 'Rook'
          content_tag(:div, '&#9820', class: 'piece-font', escape: false)
        when 'Bishop'
          content_tag(:div, '&#9821', class: 'piece-font', escape: false)
        when 'Knight'
          content_tag(:div, '&#9822', class: 'piece-font', escape: false)
        when 'Pawn'
          content_tag(:div, '&#9823', class: 'piece-font', escape: false)
        end
      end
    end
  end
end
