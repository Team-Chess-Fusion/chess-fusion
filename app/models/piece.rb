class Piece < ActiveRecord::Base
  belongs_to :game

  def check_square(x, y)
    return true if @game.pieces.where(row_coordinate: x, column_coordinate: y).any?
  end

  def check_horizontal(s_x, _d_x, s_y, d_y)
    strt = [s_y, d_y].min + 1
    fin = [s_y, d_y].max - 1

    while strt <= fin
      return true if check_square(s_x, strt)
      strt += 1
    end
  end

  def check_vertical(s_x, d_x, s_y, _d_y)
    strt = [s_x, d_x].min + 1
    fin = [s_x, d_x].max - 1

    while strt <= fin
      return true if check_square(strt, s_y)
      strt += 1
    end
  end

  def check_diagonal(s_x, d_x, s_y, d_y)
    slope = (d_y - s_y) / (d_x - s_x)
    if slope > 0
      start_x = [s_x, d_x].min + 1
      end_x = [s_x, d_x].max + 1
      start_y = [s_y, d_y].min - 1
      while start_x <= end_x
        return true if check_square(start_x, start_y)
        start_x += 1
        start_y += 1
      end
    else
      start_x = [s_x, d_x].min + 1
      end_x = [s_x, d_x].max - 1
      start_y = [s_y, d_y].max - 1
      while start_x <= end_x
        return true if check_square(start_x, start_y)
        start_x += 1
        start_y -= 1
      end
    end
  end

  def obstructed?(d_x, d_y)
    @game = Game.find(game_id)
    s_x = row_coordinate
    s_y = column_coordinate

    if s_x == d_x
      direction = 'H'
    elsif s_y == d_y
      direction = 'V'
    elsif (s_x - d_x).abs == (s_y - d_y).abs
      direction = 'D'
    else
      return 'invalid'
    end

    case direction
    when 'H'
      # horizontal
      return true if check_horizontal(s_x, d_x, s_y, d_y)

    when 'V'
      # vertical
      return true if check_vertical(s_x, d_x, s_y, d_y)

    when 'D'
      # diagonal
      return true if check_diagonal(s_x, d_x, s_y, d_y)
    end
    false
  end
end
