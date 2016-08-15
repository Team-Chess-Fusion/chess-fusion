class AddForefeitOrActiveStatus < ActiveRecord::Migration
  def change
    add_column :games, :forfeit, :boolean, default: false
    add_column :games, :active, :boolean, default: true
    add_column :games, :winner_id, :integer

    add_index :games, :forfeit
    add_index :games, :active
    add_index :games, :winner_id
  end
end
