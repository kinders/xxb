class AddDeletedAtToCatalogs < ActiveRecord::Migration
  def change
    add_column :catalogs, :deleted_at, :datetime
    add_index :catalogs, :deleted_at
  end
end
