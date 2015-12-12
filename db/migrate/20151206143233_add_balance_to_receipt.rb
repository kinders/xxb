class AddBalanceToReceipt < ActiveRecord::Migration
  def change
    add_column :receipts, :balance, :integer
  end
end
