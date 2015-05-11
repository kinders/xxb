class AddDeletedAtToTeachings < ActiveRecord::Migration
  def change
    add_column :teachings, :deleted_at, :datetime
    add_index :teachings, :deleted_at
  end
end
