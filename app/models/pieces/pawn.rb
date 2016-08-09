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

  private

  def black_pawn_valid?(destination_row, destination_column)
    return true if (destination_row - row_coordinate == 1) && ((destination_column - column_coordinate).abs <= 1)
    row_coordinate == 1 && (destination_row - row_coordinate) == 2 &&
      (destination_column == column_coordinate) && !obstructed?(destination_row, destination_column)
  end

  def white_pawn_valid?(destination_row, destination_column)
    return true if (row_coordinate - destination_row == 1) && ((destination_column - column_coordinate).abs <= 1)
    row_coordinate == 6 && (row_coordinate - destination_row) == 2 &&
      (destination_column == column_coordinate) && !obstructed?(destination_row, destination_column)
  end
end
