class AddEnPassantStatus < ActiveRecord::Migration
  def change
    add_column :pieces, :en_passant, :boolean
  end
end
