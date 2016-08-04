class Piece < ActiveRecord::Base
  belongs_to :game

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
      strt = [s_y, d_y].min + 1
      fin = [s_y, d_y].max - 1

      while strt <= fin
        if @game.pieces.where(row_coordinate: s_x, column_coordinate: strt).any?
          return true
        else
          strt += 1
        end
      end

    when 'V'
      strt = [s_x, d_x].min + 1
      fin = [s_x, d_x].max - 1

      while strt <= fin
        if @game.pieces.where(row_coordinate: strt, column_coordinate: s_y).any?
          return true
        else
          strt += 1
        end
      end

    when 'D'
      # diagonal
      slope = (d_y - s_y) / (d_x - s_x)
      if slope > 0
        start_x = [s_x, d_x].min + 1
        end_x = [s_x, d_x].max + 1
        start_y = [s_y, d_y].min - 1
        while start_x <= end_x
          if @game.pieces.where(row_coordinate: start_x, column_coordinate: start_y).any?
            return true
          else
            start_x += 1
            start_y += 1
          end
        end
      else
        start_x = [s_x, d_x].min + 1
        end_x = [s_x, d_x].max - 1
        start_y = [s_y, d_y].max - 1
        while start_x <= end_x
          if @game.pieces.where(row_coordinate: start_x, column_coordinate: start_y).any?
            return true
          else
            start_x += 1
            start_y -= 1
          end
        end
      end
    end
    return false
  end
end
