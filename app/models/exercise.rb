class Exercise < ApplicationRecord
  resourcify
  belongs_to :user
  belongs_to :tutor
  belongs_to :practice
  acts_as_paranoid
  validates :serial, :user_id, :tutor_id, :practice_id, presence: true
end
