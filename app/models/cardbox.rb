class Cardbox < ApplicationRecord
  resourcify
  belongs_to :user
  belongs_to :lesson
  has_many :cards, dependent: :destroy
  has_many :quizzes, dependent: :destroy
  acts_as_paranoid
  validates :name, :user_id, presence: true
end
