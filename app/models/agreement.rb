class Agreement < ApplicationRecord
  belongs_to :user
  belongs_to :comment
  acts_as_paranoid
  validates :user_id, :comment_id, presence: true
end
