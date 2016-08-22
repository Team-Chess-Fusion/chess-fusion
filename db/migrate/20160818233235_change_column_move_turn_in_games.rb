class ChangeColumnMoveTurnInGames < ActiveRecord::Migration
  def change
    change_column :games, :move_turn, :string, default: 'white'
  end
end
