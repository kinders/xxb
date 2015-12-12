class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.references :user, index: true
      t.integer :active_time_before_charge
      t.integer :money
      t.integer :time_length
      t.integer :active_time_after_charge
      t.integer :cashier
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :receipts, :deleted_at
    add_foreign_key :receipts, :users
  end
end
