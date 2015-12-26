class CreateQuizItems < ActiveRecord::Migration
  def change
    create_table :quiz_items do |t|
      t.references :user, index: true
      t.references :quiz, index: true
      t.references :practice, index: true
      t.boolean :isright
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :quiz_items, :deleted_at
    add_foreign_key :quiz_items, :users
    add_foreign_key :quiz_items, :quizzes
    add_foreign_key :quiz_items, :practices
  end
end
