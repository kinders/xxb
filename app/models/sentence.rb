class Sentence < ActiveRecord::Base
  belongs_to :lesson
  has_many :word_parsers
  acts_as_paranoid
  validates :name, :lesson_id, presence: true
end
