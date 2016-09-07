class Piece < ActiveRecord::Base
  belongs_to :game

  def obstructed?(destination_row, destination_column)
    if row_coordinate == destination_row
      return check_horizontal(destination_column)
    elsif column_coordinate == destination_column
      return check_vertical(destination_row)
    elsif (row_coordinate - destination_row).abs == (column_coordinate - destination_column).abs
      return check_diagonal(destination_row, destination_column)
    else
      return 'invalid move'
    end
  end

  def move_to!(new_row_coordinate, new_column_coordinate)
    return 'invalid move' if color != game.current_move_color
    return 'invalid move' if type == 'King' && game.location_is_under_attack_by_color?(game.opposite_color(color), new_row_coordinate, new_column_coordinate)
    move_piece(new_row_coordinate, new_column_coordinate)
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

  def check_horizontal(destination_column)
    start = [column_coordinate, destination_column].min + 1
    finish = [column_coordinate, destination_column].max - 1

    while start <= finish
      return true if square_taken?(row_coordinate, start)
      start += 1
    end
    false
  end

  def check_vertical(destination_row)
    start = [row_coordinate, destination_row].min + 1
    finish = [row_coordinate, destination_row].max - 1

    while start <= finish
      return true if square_taken?(start, column_coordinate)
      start += 1
    end
    false
  end

  def check_diagonal(destination_row, destination_column)
    slope = (destination_column - column_coordinate) / (destination_row - row_coordinate)
    start_x = [row_coordinate, destination_row].min + 1
    if slope > 0
      end_x = [row_coordinate, destination_row].max - 1
      start_y = [column_coordinate, destination_column].min + 1
      while start_x <= end_x
        return true if square_taken?(start_x, start_y)
        start_x += 1
        start_y += 1
      end
    else
      end_x = [row_coordinate, destination_row].max - 1
      start_y = [column_coordinate, destination_column].max - 1
      while start_x <= end_x
        return true if square_taken?(start_x, start_y)
        start_x += 1
        start_y -= 1
      end
    end
    false
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
end
