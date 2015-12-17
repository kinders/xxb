class Cardbox < ActiveRecord::Base
  resourcify
  belongs_to :user
  belongs_to :lesson
  has_many :cards, dependent: :destroy
  acts_as_paranoid
  validates :name, :user_id, presence: true
end
