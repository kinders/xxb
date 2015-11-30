class Sectionalization < ActiveRecord::Base
  belongs_to :user
  belongs_to :classroom
  has_many :teams, dependent: :destroy
  resourcify
  acts_as_paranoid
  validates :user_id, :classroom_id, :name,  presence: true
end
