class Discussion < ActiveRecord::Base
  belongs_to :user
  belongs_to :classroom
  belongs_to :lesson
  belongs_to :teaching
  belongs_to :textbook
  resourcify
  acts_as_paranoid
  validates :user_id, :classroom_id, presence: true
end
