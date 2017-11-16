class CreateWordorders < ActiveRecord::Migration
  def change
    create_table :wordorders do |t|
      t.references :user, index: true
      t.references :wordmap, index: true
      t.references :word, index: true
      t.integer :serial
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :wordorders, :deleted_at
    add_foreign_key :wordorders, :users
    add_foreign_key :wordorders, :wordmaps
    add_foreign_key :wordorders, :words
  end
end
