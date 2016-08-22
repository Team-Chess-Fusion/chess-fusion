class FixColumnNameInGames < ActiveRecord::Migration
  def change
    rename_column :games, :move_turn, :current_move_color
  end
end
