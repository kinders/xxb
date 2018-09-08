class Plan < ApplicationRecord
  resourcify
  belongs_to :user
  belongs_to :teaching
  belongs_to :tutor
  acts_as_paranoid
  validates :serial, :tutor_id, presence: true

end
