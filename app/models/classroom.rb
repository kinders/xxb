class Classroom < ActiveRecord::Base
  belongs_to :user
  has_many :members
  resourcify
  acts_as_paranoid
  validates :name, presence: true
end
