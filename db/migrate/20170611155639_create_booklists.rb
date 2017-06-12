class CreateBooklists < ActiveRecord::Migration
  def change
    create_table :booklists do |t|
      t.references :user, index: true
      t.references :textbook, index: true
      t.decimal :serial
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :booklists, :deleted_at
    add_foreign_key :booklists, :users
    add_foreign_key :booklists, :textbooks
  end
end
