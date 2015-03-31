class Lesson < ActiveRecord::Base
  rolify
  belongs_to :user
  has_many :tutor

  has_many :practice, through: :tutor
end
