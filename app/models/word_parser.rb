class WordParser < ActiveRecord::Base
  belongs_to :word
  belongs_to :lesson
  acts_as_paranoid
  validates :word_id, :lesson_id, presence: true
end
