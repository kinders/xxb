class AddDeletedAtToExercises < ActiveRecord::Migration
  def change
    add_column :exercises, :deleted_at, :datetime
    add_index :exercises, :deleted_at
  end
end
