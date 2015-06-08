class Classroom < ActiveRecord::Base
  belongs_to :user
  has_many :members
  has_many :teachers
  resourcify
  acts_as_paranoid
  validates :name, presence: true

end
