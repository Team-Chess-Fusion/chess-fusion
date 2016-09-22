class Pawn < Piece
  def valid_move?(destination_row, destination_column)
    prevent_column_move = color == 'black' ? (row_coordinate - destination_row == 1) : (destination_row - destination_row == 1)
    if check_enpassant_status == true
      (column_coordinate != destination_column) && prevent_column_move && !square_taken?(destination_row, destination_column)
      return true
    end

    return false if (destination_column == column_coordinate) && ((destination_row - row_coordinate).abs == 1) &&
                    square_taken?(destination_row, destination_column)
    case color
    when 'black'
      black_pawn_valid?(destination_row, destination_column)

    when 'white'
      white_pawn_valid?(destination_row, destination_column)
    end
  end

  def capture_enpassant
    opposing_color = game.opposite_color(color)
    left = left_piece_check
    right = right_piece_check
    if !left.nil?
      left.type == 'Pawn' && left.color == opposing_color
      opposing_pawn = left
    elsif !right.nil?
      right.type == 'Pawn' && right.color == opposing_color
      opposing_pawn = right
    else
      return false
    end
    return false if opposing_pawn.en_passant == false
    add_coordinate = color == 'black' ? -1 : 1
    move_to!((opposing_pawn.row_coordinate + add_coordinate), opposing_pawn.column_coordinate)
    opposing_pawn.update_attributes(row_coordinate: nil, column_coordinate: nil)
    true
  end

  private

  def black_pawn_valid?(destination_row, destination_column)
    obstructed_check = Piece::Obstructed.new(self, destination_row, destination_column)
    return true if (row_coordinate - destination_row == 1) && (destination_column == column_coordinate)
    return true if (row_coordinate - destination_row == 1) && ((destination_column - column_coordinate).abs == 1) && square_taken?(destination_row, destination_column)

    row_coordinate == 6 && (row_coordinate - destination_row) == 2 &&
      (destination_column == column_coordinate) && !obstructed_check.run && !square_taken?(destination_row, destination_column)
  end

  def white_pawn_valid?(destination_row, destination_column)
    obstructed_check = Piece::Obstructed.new(self, destination_row, destination_column)
    return true if (destination_row - row_coordinate == 1) && (destination_column == column_coordinate)
    return true if (destination_row - row_coordinate == 1) && ((destination_column - column_coordinate).abs == 1) && square_taken?(destination_row, destination_column)

    row_coordinate == 1 && (destination_row - row_coordinate) == 2 &&
      (destination_column == column_coordinate) && !obstructed_check.run && !square_taken?(destination_row, destination_column)
  end
end
