class Observation < ActiveRecord::Base
  belongs_to :user
  belongs_to :homework
  resourcify
  acts_as_paranoid
  validates :user_id, :student, :point, :homework_id, presence: true
end
