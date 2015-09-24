class Classroom < ActiveRecord::Base
  belongs_to :user
  has_many :members
  has_many :teachers
  has_many :cadres
  has_many :badrecord
  resourcify
  acts_as_paranoid
  validates :name, presence: true

end
