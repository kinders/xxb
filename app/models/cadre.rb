class Cadre < ActiveRecord::Base
  belongs_to :user
  belongs_to :classroom
  belongs_to :member
  belongs_to :team
  resourcify
  acts_as_paranoid
  validates :user_id, :classroom, :member_id, :position,  presence: true
end
