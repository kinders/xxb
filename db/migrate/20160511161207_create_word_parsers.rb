class CreateWordParsers < ActiveRecord::Migration
  def change
    create_table :word_parsers do |t|
      t.references :word, index: true
      t.references :lesson, index: true
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :word_parsers, :deleted_at
    add_foreign_key :word_parsers, :words
    add_foreign_key :word_parsers, :lessons
  end
end
