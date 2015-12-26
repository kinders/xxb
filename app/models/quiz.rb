class Quiz < ActiveRecord::Base
  belongs_to :user
  belongs_to :cardbox
  has_many :quiz_items, dependent: :destroy
  acts_as_paranoid
  validates :cardbox_id, :user_id, :title, :number, :repetition, presence: true
  validates :number, numericality: { only_integer: true, greater_than: 0}
  validates :repetition, numericality: { only_integer: true, greater_than: 0, less_than: 4}
  validates :duration, numericality: { only_integer: true, greater_than: 0, less_than: 3601}, allow_blank: true
end
