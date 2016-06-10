class CreateMeanings < ActiveRecord::Migration
  def change
    create_table :meanings do |t|
      t.text :content
      t.references :word, index: true
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :meanings, :deleted_at
    add_foreign_key :meanings, :words
  end
end
