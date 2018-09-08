class Paperitem < ApplicationRecord
  belongs_to :user
  belongs_to :paper
  belongs_to :practice
  resourcify
  acts_as_paranoid
  validates :user_id, :paper_id, :practice_id, presence: true
end
