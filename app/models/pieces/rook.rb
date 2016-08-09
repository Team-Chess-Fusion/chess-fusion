class Rook < Piece
  def valid_move?(row_destination, column_destination)
    row_move = (row_coordinate - row_destination).abs
    col_move = (column_coordinate - column_destination).abs
    (row_move == 0 || col_move == 0)
  end
end
