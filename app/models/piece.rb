class Piece < ActiveRecord::Base
  belongs_to :game

  def move_to!(new_row_coordinate, new_column_coordinate)
    return 'invalid move' if color != game.current_move_color
    return 'invalid move' if type == 'King' && game.location_is_under_attack_by_color?(game.opposite_color(color), new_row_coordinate, new_column_coordinate)
    move_piece(new_row_coordinate, new_column_coordinate)
  end

  def change_enpassant_status
    return nil unless is_a? Pawn
    if (row_coordinate == 4 || row_coordinate == 3) && en_passant.nil?
      update_attributes(en_passant: true)
      return true
    elsif game.pieces.where(en_passant: true) && game.current_move_color == color
      update_attributes(en_passant: false)
      return false
    else
      update_attributes(en_passant: false)
      return false
    end
  end

  def check_enpassant_status
    opposing_color = game.opposite_color(color)
    left = left_piece_check
    right = right_piece_check
    if !left.nil?
      return false if left.type != 'Pawn' && left.color != opposing_color
      return left.en_passant
    elsif !right.nil?
      return false if right.type != 'Pawn' && right.color != opposing_color
      return right.en_passant
    else
      return false
    end
  end

  def capture_for_enpassant
    return nil unless is_a? Pawn
    case color
    when 'white'
      return false if row_coordinate != 4 || capture_enpassant == false
      return true
    when 'black'
      return false if row_coordinate != 3 || capture_enpassant == false
      return true
    end
    true
  end

  private

  def square_taken?(x, y)
    game.pieces.where(row_coordinate: x, column_coordinate: y).any?
  end

  def move_piece(row, col)
    saved_state = save_game_data(row, col)
    return update_piece_after_move(saved_state, row, col) unless square_taken?(row, col)

    other_piece = game.pieces.find_by(row_coordinate: row, column_coordinate: col)
    if color == other_piece.color
      if type == 'King' && other_piece.type == 'Rook' && can_castle?(other_piece)
        castle!(other_piece)
        game.update_attributes(current_move_color: game.opposite_color(game.current_move_color))
        return 'castling'
      else
        return 'invalid move'
      end
    else
      update_pieces_after_capture(saved_state, row, col, other_piece)
    end
  end

  def check_adjacent_left(column_coordinate)
    game.pieces.find_by(column_coordinate: column_coordinate - 1, row_coordinate: row_coordinate)
  end

  def check_adjacent_right(column_coordinate)
    game.pieces.find_by(column_coordinate: column_coordinate + 1, row_coordinate: row_coordinate)
  end

  def save_game_data(row, col)
    original_row = row_coordinate
    original_col = column_coordinate
    original_has_moved = has_moved?
    if square_taken?(row, col)
      other_piece = game.pieces.find_by(row_coordinate: row, column_coordinate: col)
      if other_piece.color != color
        other_row = other_piece.row_coordinate
        other_col = other_piece.column_coordinate
        other_has_moved = other_piece.has_moved?
      end
    end
    data_array = [original_row, original_col, original_has_moved, other_piece, other_row, other_col, other_has_moved]
    data_array
  end

  def reset_state(saved_state, move_type)
    original_row, original_col, original_has_moved, other_piece, other_row, other_col, other_has_moved = saved_state
    update_attributes(row_coordinate: original_row, column_coordinate: original_col, has_moved?: original_has_moved)
    game.update_attributes(current_move_color: game.opposite_color(game.current_move_color))
    if move_type == 'captured'
      other_piece.update_attributes(row_coordinate: other_row, column_coordinate: other_col, has_moved?: other_has_moved)
    end
  end

  def verify_check_status(saved_state, move_type)
    king = game.in_check?
    return move_type unless !king.nil? && king.color == color
    reset_state(saved_state, move_type)
    'invalid move'
  end

  def update_pieces_after_capture(saved_state, row, col, other_piece)
    other_piece.update_attributes(row_coordinate: nil, column_coordinate: nil)
    update_attributes(row_coordinate: row, column_coordinate: col, has_moved?: true)
    game.update_attributes(current_move_color: game.opposite_color(game.current_move_color))

    verify_check_status(saved_state, 'captured')
  end

  def update_piece_after_move(saved_state, row, col)
    update_attributes(row_coordinate: row, column_coordinate: col, has_moved?: true)
    game.update_attributes(current_move_color: game.opposite_color(game.current_move_color))
    verify_check_status(saved_state, 'moved')
  end

  def left_piece_check
    game.pieces.find_by(column_coordinate: column_coordinate - 1, row_coordinate: row_coordinate)
  end

  def right_piece_check
    game.pieces.find_by(column_coordinate: column_coordinate + 1, row_coordinate: row_coordinate)
  end
end
