class Fee < ApplicationRecord
  belongs_to :user
  resourcify
  acts_as_paranoid
  validates :serial, :user_id, :price, presence: true
end
