class Homework < ApplicationRecord
  belongs_to :user
  belongs_to :classroom
  belongs_to :subject
  has_many :observations
  resourcify
  acts_as_paranoid
  validates :user_id, :subject_id, :title, presence: true
end
