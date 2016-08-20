class Pawn < Piece
  def valid_move?(destination_row, destination_column)
    return false if (destination_column == column_coordinate) && ((destination_row - row_coordinate).abs == 1) &&
                    square_taken?(destination_row, destination_column)

    case color
    when 'black'
      black_pawn_valid?(destination_row, destination_column)
    when 'white'
      white_pawn_valid?(destination_row, destination_column)
    end
  end

  def change_enpassant_status
    case color
    when 'black'
      update_attributes(en_passant: false) if row_coordinate == 5
    when 'white'
      update_attributes(en_passant: false) if row_coordinate == 2
    end
  end

  def capture_for_enpassant
    case color
    when 'white'
      return false if row_coordinate != 4
      if square_taken?(row_coordinate, column_coordinate - 1)
        check_adjacent_left(column_coordinate).type == 'Pawn' && check_adjacent_left(column_coordinate).color == 'black'
        opposing_pawn = check_adjacent_left(column_coordinate)
        return false if opposing_pawn.en_passant == false
        move_to!(opposing_pawn.row_coordinate + 1, opposing_pawn.column_coordinate)
        opposing_pawn.update_attributes(row_coordinate: nil, column_coordinate: nil)
      elsif square_taken?(row_coordinate, column_coordinate + 1)
        check_adjacent_right(column_coordinate).type == 'Pawn' && check_adjacent_right(column_coordinate).color == 'black'
        opposing_pawn = check_adjacent_right(column_coordinate)
        return false if opposing_pawn.en_passant == false
        move_to!(opposing_pawn.row_coordinate + 1, opposing_pawn.column_coordinate)
        opposing_pawn.update_attributes(row_coordinate: nil, column_coordinate: nil)
      else
        false
      end

    when 'black'
      return false if row_coordinate != 3
      if square_taken?(row_coordinate, column_coordinate - 1)
        check_adjacent_left(column_coordinate).type == 'Pawn' && check_adjacent_left(column_coordinate).color == 'white'
        opposing_pawn = check_adjacent_left(column_coordinate)
        return false if opposing_pawn.en_passant == false
        move_to!(opposing_pawn.row_coordinate - 1, opposing_pawn.column_coordinate)
        opposing_pawn.update_attributes(row_coordinate: nil, column_coordinate: nil)
      elsif square_taken?(row_coordinate, column_coordinate + 1)
        check_adjacent_right(column_coordinate).type == 'Pawn' && check_adjacent_right(column_coordinate).color == 'white'
        opposing_pawn = check_adjacent_right(column_coordinate)
        return false if opposing_pawn.en_passant == false
        move_to!(opposing_pawn.row_coordinate - 1, opposing_pawn.column_coordinate)
        opposing_pawn.update_attributes(row_coordinate: nil, column_coordinate: nil)
      else
        false
      end
    end
  end

  private

  def black_pawn_valid?(destination_row, destination_column)
    return true if (row_coordinate - destination_row == 1) && ((destination_column - column_coordinate).abs <= 1)
    row_coordinate == 6 && (row_coordinate - destination_row) == 2 &&
      (destination_column == column_coordinate) && !obstructed?(destination_row, destination_column)
  end

  def white_pawn_valid?(destination_row, destination_column)
    return true if (destination_row - row_coordinate == 1) && ((destination_column - column_coordinate).abs <= 1)
    row_coordinate == 1 && (destination_row - row_coordinate) == 2 &&
      (destination_column == column_coordinate) && !obstructed?(destination_row, destination_column)
  end
end
