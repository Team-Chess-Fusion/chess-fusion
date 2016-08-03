class Piece < ActiveRecord::Base
  belongs_to :game

  def obstructed?(d_x, d_y)
    @game = Game.find(game_id)
    s_x = row_coordinate
    s_y = column_coordinate

    if s_x == d_x
      # horizontal
      # puts "horizontal move from #{s_x} #{s_y} to #{d_x} #{d_y}"

      strt = [s_y, d_y].min + 1
      fin = [s_y, d_y].max - 1

      while strt <= fin
        if @game.pieces.where(row_coordinate: s_x, column_coordinate: strt).empty?
          strt += 1
        else
          return true
        end
        return false
      end

    elsif s_y == d_y
      # vertical
      # puts "vertical move from #{s_x} #{s_y} to #{d_x} #{d_y}"

      strt = [s_x, d_x].min + 1
      fin = [s_x, d_x].max - 1

      while strt <= fin
        if @game.pieces.where(row_coordinate: strt, column_coordinate: s_y).empty?
          strt += 1
        else
          return true
        end
        return false
      end

    elsif (s_x - d_x).abs == (s_y - d_y).abs
      # diagonal
      # puts "diagonal move from #{s_x} #{s_y} to #{d_x} #{d_y}"

      slope = (d_y - s_y) / (d_x - s_x)
      if slope > 0
        start_x = [s_x, d_x].min + 1
        end_x = [s_x, d_x].max + 1
        start_y = [s_y, d_y].min - 1
        while start_x <= end_x
          if @game.pieces.where(row_coordinate: start_x, column_coordinate: start_y).empty?
            start_x += 1
            start_y += 1
          else
            return true
          end
          return false
        end
      else
        start_x = [s_x, d_x].min + 1
        end_x = [s_x, d_x].max - 1
        start_y = [s_y, d_y].max - 1
        while start_x <= end_x
          if @game.pieces.where(row_coordinate: start_x, column_coordinate: start_y).empty?
            start_x += 1
            start_y -= 1
          else
            return true
          end
          return false
        end
      end
    else
      # puts "invalid move from #{s_x} #{s_y} to #{d_x} #{d_y}"
      return 'invalid'
    end
  end
end
