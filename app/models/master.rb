class Master < ApplicationRecord
  resourcify
  belongs_to :user
  acts_as_paranoid
  validates :user_id, uniqueness: true, presence: true
end
