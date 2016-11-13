class Sentence < ActiveRecord::Base
  belongs_to :lesson
  has_many :word_parsers
  has_many :words, through: :word_parsers
  has_many :comments
  acts_as_paranoid
  validates :name, :lesson_id, presence: true
end
