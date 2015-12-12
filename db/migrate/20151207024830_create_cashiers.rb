class CreateCashiers < ActiveRecord::Migration
  def change
    create_table :cashiers do |t|
      t.references :user, index: true
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :cashiers, :deleted_at
    add_foreign_key :cashiers, :users
  end
end
