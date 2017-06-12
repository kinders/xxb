class Textbook < ActiveRecord::Base
  resourcify
  belongs_to :user
  has_one :roadmap
  has_many :catalogs, dependent: :destroy
  has_many :lessons, through: :catalogs
  has_many :discussions,  dependent: :destroy
  has_many :booklists,  dependent: :destroy
  acts_as_paranoid
  validates :title, :serial, presence: true
end
