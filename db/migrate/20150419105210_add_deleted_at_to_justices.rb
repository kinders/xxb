class AddDeletedAtToJustices < ActiveRecord::Migration
  def change
    add_column :justices, :deleted_at, :datetime
    add_index :justices, :deleted_at
  end
end
