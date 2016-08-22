class AddMoveTurnToGames < ActiveRecord::Migration
  def change
    add_column :games, :move_turn, :string
  end
end
