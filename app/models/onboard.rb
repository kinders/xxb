class Onboard < ActiveRecord::Base
  belongs_to :user
  resourcify
  acts_as_paranoid
  validates :user_id, :begin_at, :expire_at, presence: true
end
