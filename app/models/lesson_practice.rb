class LessonPractice < ApplicationRecord
  belongs_to :lesson
  belongs_to :practice
  acts_as_paranoid
  validates :lesson_id, :practice_id, presence: true
end
