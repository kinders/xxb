class AddLessonIdToEvaluations < ActiveRecord::Migration
  def change
    add_reference :evaluations, :lesson, index: true
    add_foreign_key :evaluations, :lessons
  end
end
