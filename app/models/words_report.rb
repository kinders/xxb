class WordsReport < ApplicationRecord
  belongs_to :lesson
  acts_as_paranoid
  validates :lesson_id, :md,  presence: true
end
