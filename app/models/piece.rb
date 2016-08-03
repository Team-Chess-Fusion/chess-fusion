class Piece < ActiveRecord::Base
  belongs_to :game

  def obstructed?(destination_x, destination_y)
    
    @game = Game.find(self.game_id)
    @piece = self

    # @wking = @game.pieces.where(type: 'King', color: 'White')
    # puts "white king is #{@wking.inspect}"
    # puts "inspect piece #{@piece.inspect}"

    s_x = @piece.row_coordinate
    s_y = @piece.column_coordinate
    d_x = destination_x
    d_y = destination_y

    if s_x == d_x
      # horizontal
      puts "horizontal move from #{s_x} #{s_y} to #{d_x} #{d_y}"

      if s_y < d_y
        strt = s_y + 1
        fin = d_y - 1
      else
        strt = d_y + 1
        fin = s_y - 1
      end
      while strt <= fin
        if @game.pieces.where(row_coordinate: s_x, column_coordinate: strt).empty?
          strt = strt + 1
        else
          return true
        end
        return false
      end

    
    elsif s_y == d_y
        # vertical
        puts "vertical move from #{s_x} #{s_y} to #{d_x} #{d_y}"

        if s_x < d_x
          strt = s_x + 1
          fin = d_x - 1
        else
          strt = d_x + 1
          fin = s_x - 1
        end
        while strt <= fin
          if @game.pieces.where(row_coordinate: strt, column_coordinate: s_y).empty?
            strt = strt + 1
          else
            return true
          end
          return false
        end
  
    elsif ((s_x - d_x).abs == (s_y - d_y).abs)
      #diagonal
      puts "diagonal move from #{s_x} #{s_y} to #{d_x} #{d_y}"
      



    else
      puts "invalid move from #{s_x} #{s_y} to #{d_x} #{d_y}"
      return "invalid"
    end
  end
end
