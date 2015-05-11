class AddDeletedAtToEvaluations < ActiveRecord::Migration
  def change
    add_column :evaluations, :deleted_at, :datetime
    add_index :evaluations, :deleted_at
  end
end
