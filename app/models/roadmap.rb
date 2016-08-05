class Roadmap < ActiveRecord::Base
  resourcify
  belongs_to :user
  has_many :paces, dependent: :destroy
  has_many :lessons, through: :paces

  acts_as_paranoid
  validates :name, presence: true
end
