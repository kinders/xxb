class CreateCatalogs < ActiveRecord::Migration
  def change
    create_table :catalogs do |t|
      t.decimal :serial
      t.references :user, index: true
      t.references :textbook, index: true
      t.references :lesson, index: true

      t.timestamps null: false
    end
    add_foreign_key :catalogs, :users
    add_foreign_key :catalogs, :textbooks
    add_foreign_key :catalogs, :lessons
  end
end
