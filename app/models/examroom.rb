class Examroom < ActiveRecord::Base
  belongs_to :user
  belongs_to :classroom
  belongs_to :paper
  resourcify
  acts_as_paranoid
  validates :user_id, :classroom_id, :paper_id, presence: true
end
