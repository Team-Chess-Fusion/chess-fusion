class Piece < ActiveRecord::Base
  belongs_to :game

  def obstructed?(destination_row, destination_column)
    if row_coordinate == destination_row
      return check_horizontal(destination_column)
    elsif column_coordinate == destination_column
      return check_vertical(destination_row)
    elsif (row_coordinate - destination_row).abs == (column_coordinate - destination_column).abs
      return check_diagonal(destination_row, destination_column)
    else
      return 'invalid'
    end
  end

  def move_to!(new_row_coordinate, new_column_coordinate)
    if !square_taken?(new_row_coordinate, new_column_coordinate)
      update_attributes(row_coordinate: new_row_coordinate, column_coordinate: new_column_coordinate, has_moved?: true)
      return 'moved'
    else
      other_piece = game.pieces.find_by(row_coordinate: new_row_coordinate, column_coordinate: new_column_coordinate)
      if color == other_piece.color
        if type == 'King' && other_piece.type == 'Rook' && can_castle?(other_piece)
          castle!(other_piece)
          return 'castling'
        else
          return 'invalid'
        end
      end
      other_piece.update_attributes(row_coordinate: nil, column_coordinate: nil)
      return 'captured'
    end
  end

  private

  def square_taken?(x, y)
    game.pieces.where(row_coordinate: x, column_coordinate: y).any?
  end

  def check_horizontal(destination_column)
    start = [column_coordinate, destination_column].min + 1
    finish = [column_coordinate, destination_column].max - 1

    while start <= finish
      return true if square_taken?(row_coordinate, start)
      start += 1
    end
    false
  end

  def check_vertical(destination_row)
    start = [row_coordinate, destination_row].min + 1
    finish = [row_coordinate, destination_row].max - 1

    while start <= finish
      return true if square_taken?(start, column_coordinate)
      start += 1
    end
    false
  end

  def check_diagonal(destination_row, destination_column)
    slope = (destination_column - column_coordinate) / (destination_row - row_coordinate)
    start_x = [row_coordinate, destination_row].min + 1
    if slope > 0
      end_x = [row_coordinate, destination_row].max - 1
      start_y = [column_coordinate, destination_column].min + 1
      while start_x <= end_x
        return true if square_taken?(start_x, start_y)
        start_x += 1
        start_y += 1
      end
    else
      end_x = [row_coordinate, destination_row].max - 1
      start_y = [column_coordinate, destination_column].max - 1
      while start_x <= end_x
        return true if square_taken?(start_x, start_y)
        start_x += 1
        start_y -= 1
      end
    end
    false
  end
end
