class Subject < ApplicationRecord
  belongs_to :user
  has_many :teachers
  resourcify
  acts_as_paranoid
  validates :name, :user_id, presence: true
end
