class AddDeletedAtToPractices < ActiveRecord::Migration
  def change
    add_column :practices, :deleted_at, :datetime
    add_index :practices, :deleted_at
  end
end
