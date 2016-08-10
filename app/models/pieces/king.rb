class King < Piece
  def valid_move?(destination_row, destination_column)
    (column_coordinate - destination_row).abs <= 1 && (row_coordinate - destination_column).abs <= 1
  end
end
