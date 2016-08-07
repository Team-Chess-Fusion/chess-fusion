class King < Piece
  def valid_move?(destination_row, destination_column)
    current_column_coordinate = column_coordinate
    current_row_coordinate = row_coordinate
    (current_row_coordinate - destination_row).abs <= 1 && (current_column_coordinate - destination_column).abs <= 1
  end
end
