class Bishop < Piece
  def valid_move?(row_destination, column_destination)
    row_move = (row_coordinate - row_destination).abs
    col_move = (column_coordinate - column_destination).abs

    if col_move.zero? || row_move.zero?
      false
    else
      slope = (col_move / row_move)
      slope == 1 && !obstructed?(row_destination, column_destination)
    end
  end
end
