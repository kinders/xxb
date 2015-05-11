class Textbook < ActiveRecord::Base
  resourcify
  belongs_to :user
  has_many :catalogs, dependent: :destroy
  has_many :discussion,  dependent: :destroy
  acts_as_paranoid
  validates :title, :serial, presence: true
end
