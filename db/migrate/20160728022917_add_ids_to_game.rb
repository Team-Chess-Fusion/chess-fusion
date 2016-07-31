class AddIdsToGame < ActiveRecord::Migration
  def change
    add_column :games, :black_player_id, :integer
    add_column :games, :white_player_id, :integer
  end
end
