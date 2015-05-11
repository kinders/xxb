class AddDeletedAtToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :deleted_at, :datetime
    add_index :lessons, :deleted_at
  end
end
