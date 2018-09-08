class WordParser < ApplicationRecord
  belongs_to :word
  belongs_to :lesson
  belongs_to :sentence
  acts_as_paranoid
  validates :word_id, :lesson_id, presence: true
end
