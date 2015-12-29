class Paper < ActiveRecord::Base
  belongs_to :user
  has_many :paperitems, dependent: :destroy
  has_many :papertests, dependent: :destroy
  resourcify
  acts_as_paranoid
  validates :user_id, :title, :duration, presence: true
end
