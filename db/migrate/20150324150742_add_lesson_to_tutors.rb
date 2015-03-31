class AddLessonToTutors < ActiveRecord::Migration
  def change
    add_reference :tutors, :lesson, index: true
    add_foreign_key :tutors, :lessons
  end
end
