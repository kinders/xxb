class CreatePracticeParsers < ActiveRecord::Migration
  def change
    create_table :practice_parsers do |t|
      t.references :practice, index: true
      t.references :word, index: true
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :practice_parsers, :deleted_at
    add_foreign_key :practice_parsers, :practices
    add_foreign_key :practice_parsers, :words
  end
end
