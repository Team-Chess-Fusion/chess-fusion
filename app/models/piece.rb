class Piece < ActiveRecord::Base
  belongs_to :game

  def check_square(x, y)
    game.pieces.where(row_coordinate: x, column_coordinate: y).any?
  end

  def check_horizontal(destination_column)
    strt = [column_coordinate, destination_column].min + 1
    fin = [column_coordinate, destination_column].max - 1

    while strt <= fin
      return true if check_square(row_coordinate, strt)
      strt += 1
    end
    false
  end

  def check_vertical(destination_row)
    strt = [row_coordinate, destination_row].min + 1
    fin = [row_coordinate, destination_row].max - 1

    while strt <= fin
      return true if check_square(strt, column_coordinate)
      strt += 1
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
        return true if check_square(start_x, start_y)
        start_x += 1
        start_y += 1
      end
    else
      end_x = [row_coordinate, destination_row].max - 1
      start_y = [column_coordinate, destination_column].max - 1
      while start_x <= end_x
        return true if check_square(start_x, start_y)
        start_x += 1
        start_y -= 1
      end
    end
    false
  end

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
end
