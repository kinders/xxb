class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.references :user, index: true
      t.references :cardbox, index: true
      t.string :title
      t.integer :number
      t.integer :repetition
      t.integer :duration
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :quizzes, :deleted_at
    add_foreign_key :quizzes, :users
    add_foreign_key :quizzes, :cardboxes
  end
end
