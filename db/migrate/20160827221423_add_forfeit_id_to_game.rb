class AddForfeitIdToGame < ActiveRecord::Migration
  def change
    add_column :games, :forfeit_id, :integer
  end
end
