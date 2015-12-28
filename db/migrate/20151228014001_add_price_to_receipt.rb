class AddPriceToReceipt < ActiveRecord::Migration
  def change
    add_column :receipts, :price, :integer
  end
end
