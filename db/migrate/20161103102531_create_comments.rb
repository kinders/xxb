class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.datetime :deleted_at
      t.text :content
      t.references :lesson, index: true
      t.references :sentence, index: true
      t.references :word, index: true

      t.timestamps null: false
    end
    add_index :comments, :deleted_at
    add_foreign_key :comments, :users
    add_foreign_key :comments, :lessons
    add_foreign_key :comments, :sentences
    add_foreign_key :comments, :words
  end
end
