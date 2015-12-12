class CreateWithdraws < ActiveRecord::Migration
  def change
    create_table :withdraws do |t|
      t.references :user, index: true
      t.integer :money
      t.string :memo

      t.timestamps null: false
    end
    add_foreign_key :withdraws, :users
  end
end
