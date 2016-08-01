class CreatePieces < ActiveRecord::Migration
  def change
    create_table :pieces do |t|
      t.string   :type
      t.integer  :game_id
      t.string   :color
      t.integer  :column_coordinate
      t.integer  :row_coordinate

      t.timestamps
    end
  end
end
