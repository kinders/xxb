class Paper < ActiveRecord::Base
  belongs_to :user
  has_many :paperitems, dependent: :destroy
  has_many :papertests, dependent: :destroy
  has_many :examrooms, dependent: :destroy
  resourcify
  acts_as_paranoid
  validates :user_id, :title, :duration, presence: true
end
