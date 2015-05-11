class Teaching < ActiveRecord::Base
  resourcify
  belongs_to :user
  belongs_to :lesson
  has_many :plans, dependent: :destroy
  acts_as_paranoid
  validates :title, presence: true
end
