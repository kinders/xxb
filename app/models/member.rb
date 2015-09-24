class Member < ActiveRecord::Base
  belongs_to :classroom
  belongs_to :user
  has_many :cadres
  resourcify
  acts_as_paranoid
  validates :user_id, :serial, :classroom_id, :student, presence: true
end
