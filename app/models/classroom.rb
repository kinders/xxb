class Classroom < ActiveRecord::Base
  belongs_to :user
  has_many :members, dependent: :destroy
  has_many :teachers, dependent: :destroy
  has_many :cadres, dependent: :destroy
  has_many :badrecords, dependent: :destroy
  has_many :sectionalizations, dependent: :destroy
  has_many :examrooms, dependent: :destroy
  resourcify
  acts_as_paranoid
  validates :name, presence: true

end
