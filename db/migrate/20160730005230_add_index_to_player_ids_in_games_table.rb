class AddIndexToPlayerIdsInGamesTable < ActiveRecord::Migration
  def change
    add_index :games, [:white_player_id, :black_player_id]
    add_index :games, :black_player_id
  end
end
