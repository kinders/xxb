class Team < ActiveRecord::Base
  belongs_to :user
  belongs_to :sectionalization
  has_many :players, dependent: :destroy
  has_many :classgroupscores, dependent: :destroy
  resourcify
  acts_as_paranoid
  validates :user_id, :sectionalization_id,  presence: true
end
