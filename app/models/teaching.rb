class Teaching < ApplicationRecord
  belongs_to :user
  belongs_to :lesson
  has_many :plans, dependent: :destroy
  resourcify
  acts_as_paranoid
  validates :title, presence: true
end
