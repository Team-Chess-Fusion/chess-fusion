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

  private

  def square_taken?(x, y)
    game.pieces.where(row_coordinate: x, column_coordinate: y).any?
  end

  def move_piece(row, col)
    switch_turn_color = game.opposite_color(game.current_move_color)

    if !square_taken?(row, col)
      update_attributes(row_coordinate: row, column_coordinate: col, has_moved?: true)
      game.update_attributes(current_move_color: switch_turn_color)
      return 'moved'
    else
      other_piece = game.pieces.find_by(row_coordinate: row, column_coordinate: col)
      if color == other_piece.color
        if type == 'King' && other_piece.type == 'Rook' && can_castle?(other_piece)
          castle!(other_piece)
          game.update_attributes(current_move_color: switch_turn_color)
          return 'castling'
        else
          return 'invalid move'
        end
      end

      other_piece.update_attributes(row_coordinate: nil, column_coordinate: nil)
      update_attributes(row_coordinate: row, column_coordinate: col, has_moved?: true)
      game.update_attributes(current_move_color: switch_turn_color)
      return 'captured'
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
end
