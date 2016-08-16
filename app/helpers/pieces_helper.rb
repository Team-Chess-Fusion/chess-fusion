module PiecesHelper
  def display_white_piece(piece, css_class, data)
    case piece.type
    when 'King'
      css_class += ' white-king'
    when 'Queen'
      css_class += ' white-queen'
    when 'Rook'
      css_class += ' white-rook'
    when 'Bishop'
      css_class += ' white-bishop'
    when 'Knight'
      css_class += ' white-knight'
    when 'Pawn'
      css_class += ' white-pawn'
    end
    content_tag(:p, '', class: css_class, data: { update_url: data })
  end

  def display_black_piece(piece, css_class, data)
    case piece.type
    when 'King'
      css_class += ' black-king'
    when 'Queen'
      css_class += ' black-queen'
    when 'Rook'
      css_class += ' black-rook'
    when 'Bishop'
      css_class += ' black-bishop'
    when 'Knight'
      css_class += ' black-knight'
    when 'Pawn'
      css_class += ' black-pawn'
    end
    content_tag(:p, '', class: css_class, data: { update_url: data })
  end

  def display_piece(piece, css_class)
    data = piece_path(piece)
    if piece.color == 'white'
      display_white_piece(piece, css_class, data)
    else
      display_black_piece(piece, css_class, data)
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
