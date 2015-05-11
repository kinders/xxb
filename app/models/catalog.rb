class Catalog < ActiveRecord::Base
  resourcify
  belongs_to :user
  belongs_to :textbook
  belongs_to :lesson
  acts_as_paranoid
  validates :serial, :lesson_id, presence: true
end
