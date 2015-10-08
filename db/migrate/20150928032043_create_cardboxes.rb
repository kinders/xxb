class CreateCardboxes < ActiveRecord::Migration
  def change
    create_table :cardboxes do |t|
      t.references :user, index: true
      t.string :name
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :cardboxes, :deleted_at
    add_foreign_key :cardboxes, :users
  end
end
