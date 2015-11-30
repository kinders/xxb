class Member < ActiveRecord::Base
  belongs_to :classroom
  belongs_to :user
  has_many :cadres, dependent: :destroy
  has_many :players, dependent: :destroy
  has_many :classpersonscores, dependent: :destroy

  resourcify
  acts_as_paranoid
  validates :user_id, :serial, :classroom_id, :student, presence: true
end
