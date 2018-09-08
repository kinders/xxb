class Papertest < ApplicationRecord
  belongs_to :user
  belongs_to :paper
  has_many :evaluations, dependent: :destroy
  resourcify
  acts_as_paranoid
  validates :user_id, :paper_id, :end_at, presence: true
end
