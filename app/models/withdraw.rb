class Withdraw < ApplicationRecord
  belongs_to :user
  resourcify
  acts_as_paranoid
  validates :user_id, :money, presence: true
  validates :money, numericality: { only_integer: true }
end
