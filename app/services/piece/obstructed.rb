class Piece::Obstructed
  attr_accessor :game, :piece, :destination_row, :destination_column

  def initialize(game, piece, destination_row, destination_column)
    @game = game
    @piece = piece
    @destination_row = destination_row
    @destination_column = destination_column
  end

  def run
    if piece.row_coordinate == destination_row
      return check_horizontal(destination_column)
    elsif piece.column_coordinate == destination_column
      return check_vertical(destination_row)
    elsif (piece.row_coordinate - destination_row).abs == (piece.column_coordinate - destination_column).abs
      return check_diagonal(destination_row, destination_column)
    else
      return 'invalid move'
    end
  end

  private

  def check_horizontal(destination_column)
    start = [piece.column_coordinate, destination_column].min + 1
    finish = [piece.column_coordinate, destination_column].max - 1

    while start <= finish
      return true if square_taken?(piece.row_coordinate, start)
      start += 1
    end
    false
  end

  def check_vertical(destination_row)
    start = [piece.row_coordinate, destination_row].min + 1
    finish = [piece.row_coordinate, destination_row].max - 1

    while start <= finish
      return true if square_taken?(start, piece.column_coordinate)
      start += 1
    end
    false
  end

  def check_diagonal(destination_row, destination_column)
    slope = (destination_column - piece.column_coordinate) / (destination_row - piece.row_coordinate)
    start_x = [piece.row_coordinate, destination_row].min + 1
    start_y_increment = slope > 0 ? 1 : -1
    start_y = slope > 0 ? [piece.column_coordinate, destination_column].min + start_y_increment : [piece.column_coordinate, destination_column].max + start_y_increment
    end_x = [piece.row_coordinate, destination_row].max - 1

    while start_x <= end_x
      return true if square_taken?(start_x, start_y)
      start_x += 1
      start_y += start_y_increment
    end
    false
  end

  def square_taken?(x, y)
    game.pieces.where(row_coordinate: x, column_coordinate: y).any?
  end
end
