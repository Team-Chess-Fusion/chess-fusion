class Piece::Obstructed?

  attr_accessor :piece, :destination_row, :destination_column

  def initialize(piece, destination_row, destination_column)
    @piece = piece
    @destination_row = destination_row
    @destination_column = destination_column
  end

  def run
    if row_coordinate == destination_row
      return check_horizontal(destination_column)
    elsif column_coordinate == destination_column
      return check_vertical(destination_row)
    elsif (row_coordinate - destination_row).abs == (column_coordinate - destination_column).abs
      return check_diagonal(destination_row, destination_column)
    else
      return 'invalid move'
    end
  end

  private

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
    start_y_increment = slope > 0 ? 1 : -1
    start_y = slope > 0 ? [column_coordinate, destination_column].min + start_y_increment : [column_coordinate, destination_column].max + start_y_increment
    end_x = [row_coordinate, destination_row].max - 1

    while start_x <= end_x
      return true if square_taken?(start_x, start_y)
      start_x += 1
      start_y += start_y_increment
    end
    false
  end
end
