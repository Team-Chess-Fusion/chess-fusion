class AddIndexToPieces < ActiveRecord::Migration
  def change
    add_index :pieces, :game_id
  end
end
