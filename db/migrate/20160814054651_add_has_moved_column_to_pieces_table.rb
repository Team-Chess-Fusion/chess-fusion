class AddHasMovedColumnToPiecesTable < ActiveRecord::Migration
  def change
    add_column :pieces, :has_moved?, :bool, default: false
  end
end
