class Knight < Piece
  def valid_move?(row, col)
    vertical_move = (row_coordinate - row).abs
    horizontal_move = (column_coordinate - col).abs

    horizontal_move <= 2 && vertical_move <= 2 && horizontal_move + vertical_move == 3
  end
end
