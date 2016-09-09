class Queen < Piece
  def valid_move?(row_destination, column_destination)
    obstructed_check = Piece::Obstructed.new(game, self, row_destination, column_destination)
    row_move = (row_coordinate - row_destination).abs
    col_move = (column_coordinate - column_destination).abs

    ((row_move.zero? || col_move.zero?) || (row_move == col_move)) && !obstructed_check.run
  end
end
