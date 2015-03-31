class CreatePractices < ActiveRecord::Migration
  def change
    create_table :practices do |t|
      t.string :title
      t.text :question
      t.text :answer
      t.references :user, index: true
      t.references :tutor, index: true
      t.references :lesson, index: true
      t.boolean :activate

      t.timestamps null: false
    end
    add_foreign_key :practices, :users
    add_foreign_key :practices, :tutors
    add_foreign_key :practices, :lessons
  end
end
