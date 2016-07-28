class AddIndexToPieces < ActiveRecord::Migration
  def change
  end
  add_index :pieces, :game_id
end
