class AddDeletedAtToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :deleted_at, :datetime
    add_index :plans, :deleted_at
  end
end
