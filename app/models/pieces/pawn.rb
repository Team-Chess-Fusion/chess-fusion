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

  def check_left_right_pawn(column_coordinate)
    opposing_color = game.opposite_color(color)
    left = game.pieces.find_by(column_coordinate: column_coordinate - 1, row_coordinate: row_coordinate)
    right = game.pieces.find_by(column_coordinate: column_coordinate + 1, row_coordinate: row_coordinate)
    if !left.nil?
      left.type == 'Pawn' && left.color == opposing_color
    elsif !right.nil?
      right.type == 'Pawn' && right.color == opposing_color
    else
      return false
    end
  end

  def enpassant_left
    check_left_right_pawn(column_coordinate)
    opposing_pawn = game.pieces.find_by(column_coordinate: column_coordinate - 1, row_coordinate: row_coordinate)
    return false if opposing_pawn.en_passant == false
    add_coordinate = color == 'black' ? -1 : 1
    move_to!((opposing_pawn.row_coordinate + add_coordinate), opposing_pawn.column_coordinate)
    opposing_pawn.update_attributes(row_coordinate: nil, column_coordinate: nil)
  end

  def enpassant_right
    check_left_right_pawn(column_coordinate)
    opposing_pawn = game.pieces.find_by(column_coordinate: column_coordinate + 1, row_coordinate: row_coordinate)
    return false if opposing_pawn.en_passant == false
    add_coordinate = color == 'black' ? -1 : 1
    move_to!((opposing_pawn.row_coordinate + add_coordinate), opposing_pawn.column_coordinate)
    opposing_pawn.update_attributes(row_coordinate: nil, column_coordinate: nil)
  end

  def capture_enpassant
    if square_taken?(row_coordinate, column_coordinate - 1)
      enpassant_left
    elsif square_taken?(row_coordinate, column_coordinate + 1)
      enpassant_right
    else
      return false
    end
  end

  def capture_for_enpassant
    case color
    when 'white'
      return false if row_coordinate != 4
      capture_enpassant
    when 'black'
      return false if row_coordinate != 3
      capture_enpassant
    end
  end

  private

  def black_pawn_valid?(destination_row, destination_column)
    return true if (row_coordinate - destination_row == 1) && (destination_column == column_coordinate)
    return true if (row_coordinate - destination_row == 1) && ((destination_column - column_coordinate).abs == 1) && square_taken?(destination_row, destination_column)
    row_coordinate == 6 && (row_coordinate - destination_row) == 2 &&
      (destination_column == column_coordinate) && !obstructed?(destination_row, destination_column) && !square_taken?(destination_row, destination_column)
  end

  def white_pawn_valid?(destination_row, destination_column)
    return true if (destination_row - row_coordinate == 1) && (destination_column == column_coordinate)
    return true if (destination_row - row_coordinate == 1) && ((destination_column - column_coordinate).abs == 1) && square_taken?(destination_row, destination_column)
    row_coordinate == 1 && (destination_row - row_coordinate) == 2 &&
      (destination_column == column_coordinate) && !obstructed?(destination_row, destination_column) && !square_taken?(destination_row, destination_column)
  end
end
