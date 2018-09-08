class QuizItem < ApplicationRecord
  belongs_to :user
  belongs_to :quiz
  belongs_to :practice
  acts_as_paranoid
  validates :user_id, :quiz_id, :practice_id, presence: true
end
