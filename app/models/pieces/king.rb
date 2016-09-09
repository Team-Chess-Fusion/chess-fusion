class King < Piece
  def valid_move?(destination_row, destination_column)
    destination_piece = game.pieces.find_by row_coordinate: destination_row, column_coordinate: destination_column
    return true if destination_piece.present? && destination_piece.type == 'Rook' && can_castle?(destination_piece)
    (column_coordinate - destination_column).abs <= 1 && (row_coordinate - destination_row).abs <= 1
  end

  def can_castle?(rook)
    # Not required to check if king and rook are on player's first rank as it is implied that the king or rook has moved.
    obstructed_check = Piece::Obstructed.new(game, self, rook.row_coordinate, rook.column_coordinate)
    return false if has_moved? || rook.has_moved?
    return false if obstructed_check.run
    return false if castle_into_or_through_or_out_of_check?(rook.column_coordinate)

    true
  end

  def castle!(rook)
    # can_castle? to be called before this?
    rook_dest_col = rook.column_coordinate < column_coordinate ? 3 : 5
    king_dest_col = rook.column_coordinate < column_coordinate ? 2 : 6

    update_attributes(column_coordinate: king_dest_col, has_moved?: true)
    rook.update_attributes(column_coordinate: rook_dest_col, has_moved?: true)
  end

  private

  def castle_into_or_through_or_out_of_check?(rook_col)
    opposing_color = game.opposite_color(color)

    start_col = rook_col < column_coordinate ? 2 : column_coordinate
    end_col = rook_col < column_coordinate ? column_coordinate : 6

    (start_col..end_col).each do |col|
      return true if game.location_is_under_attack_by_color?(opposing_color, row_coordinate, col)
    end

    false
  end
end
