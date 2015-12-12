class AddDeletedAtToWithdraw < ActiveRecord::Migration
  def change
    add_column :withdraws, :deleted_at, :datetime
    add_index :withdraws, :deleted_at
  end
end
