class Booklist < ApplicationRecord
  resourcify
  belongs_to :user
  belongs_to :textbook
  acts_as_paranoid
  validates :serial, :user_id, :textbook_id, presence: true
end
