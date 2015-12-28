class CreateFees < ActiveRecord::Migration
  def change
    create_table :fees do |t|
      t.references :user, index: true
      t.string :name
      t.integer :price
      t.integer :serial
      t.datetime :end_at
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :fees, :deleted_at
    add_foreign_key :fees, :users
  end
end
