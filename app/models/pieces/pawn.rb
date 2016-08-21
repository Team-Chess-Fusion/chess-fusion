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

  # Idea is that once a pawn moves up/down one row, it's no longer eligible to be captured
  # through en passant. I also added another field to the pieces table so that the game
  # can keep track the pawn's en passant status. Not sure if this is the best way to
  # track en passant status
  def change_enpassant_status
    case color
    when 'black'
      update_attributes(en_passant: false) if row_coordinate == 5
    when 'white'
      update_attributes(en_passant: false) if row_coordinate == 2
    end
  end

  # This is check whether there's a pawn of the opposing color to the left
  # the capturing pawn
  def check_left_for_pawn(column_coordinate)
    opposing_color = color == 'white' ? 'black' : 'white'
    left = game.pieces.find_by(column_coordinate: column_coordinate - 1, row_coordinate: row_coordinate)
    left.type == 'Pawn' && left.color == opposing_color
  end

  # This is check whether there's a pawn of the opposing color to the right
  # the capturing pawn
  def check_right_for_pawn(column_coordinate)
    opposing_color = color == 'white' ? 'black' : 'white'
    right = game.pieces.find_by(column_coordinate: column_coordinate + 1, row_coordinate: row_coordinate)
    right.type == 'Pawn' && right.color == opposing_color
  end

  # This is to check if the white pawn can capture a black pawn through en pasant
  def white_pawn_capture_enpassant
    # Should return false since en passant can't happen unless the white piece is already
    # at the row the black piece jumps two rows to get to
    return false if row_coordinate != 4
    # This is to check if anything exists to the left of the white pawn
    # If it's nil, move on to check to see if anything is on the right
    if square_taken?(row_coordinate, column_coordinate - 1)
      # This checks to see if the piece to the left is a pawn and an opposing color
      check_left_for_pawn(column_coordinate)
      # This assigns the black pawn a variable
      # The check_adjacent_left method is in the Piece model
      opposing_pawn = check_adjacent_left(column_coordinate)
      # Exit if the black pawn already moved one row
      return false if opposing_pawn.en_passant == false
    # This is to check anything to the right of the white pawn
    elsif square_taken?(row_coordinate, column_coordinate + 1)
      # This checks to see if the piece to the right is a pawn and an opposing color
      check_right_for_pawn(column_coordinate)
      # This assigns the black pawn a variable
      # The check_adjacent_right method is in the Piece model
      opposing_pawn = check_adjacent_right(column_coordinate)
      # Exit if the black pawn already moved one row
      return false if opposing_pawn.en_passant == false
    else
      return false
    end
    # This moves the white pawn to the black pawn's cell
    move_to!(opposing_pawn.row_coordinate + 1, opposing_pawn.column_coordinate)
    # Take the black pawn off the board since it was captured
    opposing_pawn.update_attributes(row_coordinate: nil, column_coordinate: nil)
  end

  def black_pawn_capture_enpassant
    return false if row_coordinate != 3
    if square_taken?(row_coordinate, column_coordinate - 1)
      check_left_for_pawn(column_coordinate)
      opposing_pawn = check_adjacent_left(column_coordinate)
      return false if opposing_pawn.en_passant == false
    elsif square_taken?(row_coordinate, column_coordinate + 1)
      check_right_for_pawn(column_coordinate)
      opposing_pawn = check_adjacent_right(column_coordinate)
      return false if opposing_pawn.en_passant == false
    else
      return false
    end
    move_to!(opposing_pawn.row_coordinate - 1, opposing_pawn.column_coordinate)
    opposing_pawn.update_attributes(row_coordinate: nil, column_coordinate: nil)
  end

  # Call the method for the right pawn color
  def capture_for_enpassant
    case color
    when 'white'
      white_pawn_capture_enpassant
    when 'black'
      black_pawn_capture_enpassant
    end
  end

  private

  def black_pawn_valid?(destination_row, destination_column)
    return true if (row_coordinate - destination_row == 1) && ((destination_column - column_coordinate).abs <= 1)
    row_coordinate == 6 && (row_coordinate - destination_row) == 2 &&
      (destination_column == column_coordinate) && !obstructed?(destination_row, destination_column)
  end

  def white_pawn_valid?(destination_row, destination_column)
    return true if (destination_row - row_coordinate == 1) && ((destination_column - column_coordinate).abs <= 1)
    row_coordinate == 1 && (destination_row - row_coordinate) == 2 &&
      (destination_column == column_coordinate) && !obstructed?(destination_row, destination_column)
  end
end
