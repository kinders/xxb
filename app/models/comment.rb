class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :lesson
  belongs_to :sentence
  belongs_to :word
  has_many :agreements

  acts_as_paranoid
  validates :content, :user_id, :lesson_id, :sentence_id, :word_id, presence: true
end
