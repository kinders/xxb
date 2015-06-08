class Teacher < ActiveRecord::Base
  belongs_to :user
  belongs_to :classroom
  belongs_to :subject
  resourcify
  acts_as_paranoid
  validates :user_id, :classroom_id, :mentor, :subject_id,  presence: true
end
