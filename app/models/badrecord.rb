class Badrecord < ActiveRecord::Base
  belongs_to :user
  belongs_to :classroom
  belongs_to :subject
  resourcify
  acts_as_paranoid
  validates :user_id, :troublemaker, :classroom_id, :troubletime, :subject_id, :description,  presence: true
end
