class Cardbox < ActiveRecord::Base
  resourcify
  belongs_to :user
  has_many :cards, dependent: :destroy
  acts_as_paranoid
  validates :name, :user_id, presence: true
end
