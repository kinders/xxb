class CreateSentences < ActiveRecord::Migration
  def change
    create_table :sentences do |t|
      t.references :lesson, index: true
      t.string :name
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :sentences, :deleted_at
    add_foreign_key :sentences, :lessons
  end
end
