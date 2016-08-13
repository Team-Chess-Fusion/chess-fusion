module PiecesHelper
  def display_white_piece(piece, css_class)
    case piece.type
    when 'King'
      css_class += ' white-king'
      content_tag(:p, '', class: css_class)
    when 'Queen'
      css_class += ' white-queen'
      content_tag(:p, '', class: css_class)
    when 'Rook'
      css_class += ' white-rook'
      content_tag(:p, '', class: css_class)
    when 'Bishop'
      css_class += ' white-bishop'
      content_tag(:p, '', class: css_class)
    when 'Knight'
      css_class += ' white-knight'
      content_tag(:p, '', class: css_class)
    when 'Pawn'
      css_class += ' white-pawn'
      content_tag(:p, '', class: css_class)
    end
  end

  def display_black_piece(piece, css_class)
    case piece.type
    when 'King'
      css_class += ' black-king'
      content_tag(:p, '', class: css_class)
    when 'Queen'
      css_class += ' black-queen'
      content_tag(:p, '', class: css_class)
    when 'Rook'
      css_class += ' black-rook'
      content_tag(:p, '', class: css_class)
    when 'Bishop'
      css_class += ' black-bishop'
      content_tag(:p, '', class: css_class)
    when 'Knight'
      css_class += ' black-knight'
      content_tag(:p, '', class: css_class)
    when 'Pawn'
      css_class += ' black-pawn'
      content_tag(:p, '', class: css_class)
    end
  end

  def display_piece(piece, css_class)
    if piece.color == 'white'
      display_white_piece(piece, css_class)
    else
      display_black_piece(piece, css_class)
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
