class CreateLessonPractices < ActiveRecord::Migration
  def change
    create_table :lesson_practices do |t|
      t.references :lesson, index: true
      t.references :practice, index: true
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :lesson_practices, :deleted_at
    add_foreign_key :lesson_practices, :lessons
    add_foreign_key :lesson_practices, :practices
  end
end
