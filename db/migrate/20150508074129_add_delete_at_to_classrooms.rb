class AddDeleteAtToClassrooms < ActiveRecord::Migration
  def change
    add_column :classrooms, :deleted_at, :datetime
    add_index :classrooms, :deleted_at
  end
end
