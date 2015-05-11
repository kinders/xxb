class AddDeletedAtToTextbooks < ActiveRecord::Migration
  def change
    add_column :textbooks, :deleted_at, :datetime
    add_index :textbooks, :deleted_at
  end
end
