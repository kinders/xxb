class Classpersonscore < ApplicationRecord
  belongs_to :user
  belongs_to :member
  belongs_to :classgroupscore
  resourcify
  acts_as_paranoid
  validates :user_id, :member_id, :score, :classgroupscore_id,  presence: true
end
