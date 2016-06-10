class CreatePhoneticNotations < ActiveRecord::Migration
  def change
    create_table :phonetic_notations do |t|
      t.references :phonetic, index: true
      t.references :word, index: true
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :phonetic_notations, :deleted_at
    add_foreign_key :phonetic_notations, :phonetics
    add_foreign_key :phonetic_notations, :words
  end
end
