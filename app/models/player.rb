class Player < ApplicationRecord
  belongs_to :user
  belongs_to :team
  belongs_to :member
  resourcify
  acts_as_paranoid
  validates :user_id, :team_id, :member_id,  presence: true
end
