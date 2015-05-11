class AddDeletedAtToTutors < ActiveRecord::Migration
  def change
    add_column :tutors, :deleted_at, :datetime
    add_index :tutors, :deleted_at
  end
end
