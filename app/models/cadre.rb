class Cadre < ActiveRecord::Base
  belongs_to :user
  belongs_to :member
  resourcify
  acts_as_paranoid
  validates :user_id, :member_id, :position,  presence: true
end
