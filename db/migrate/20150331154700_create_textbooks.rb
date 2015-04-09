class CreateTextbooks < ActiveRecord::Migration
  def change
    create_table :textbooks do |t|
      t.string :title
      t.text :description
      t.decimal :serial
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :textbooks, :users
  end
end
