class PracticeParser < ApplicationRecord
  belongs_to :practice
  belongs_to :word
  acts_as_paranoid
  validates :word_id, :practice_id, presence: true
end
