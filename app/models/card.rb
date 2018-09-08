class Card < ApplicationRecord
  belongs_to :user
  belongs_to :practice
  belongs_to :cardbox
  resourcify
  acts_as_paranoid
  validates :user_id, :cardbox_id, :practice_id, :sequence,:serial,  presence: true
end
