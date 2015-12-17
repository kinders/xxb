class AddLessonIdToCardbox < ActiveRecord::Migration
  def change
    add_reference :cardboxes, :lesson, index: true
    add_foreign_key :cardboxes, :lessons
  end
end
