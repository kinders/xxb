class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.references :user, index: true
      t.references :tutor, index: true
      t.references :practice, index: true
      t.string :title
      t.text :question
      t.text :answer
      t.text :your_answer
      t.decimal :score

      t.timestamps null: false
    end
    add_foreign_key :evaluations, :users
    add_foreign_key :evaluations, :tutors
    add_foreign_key :evaluations, :practices
  end
end
