class Justice < ActiveRecord::Base
  resourcify
  belongs_to :user
  belongs_to :evaluation
  belongs_to :practice
  validates :score, presence: true, numericality: {less_than_or_equal_to: :p_score, greater_than_or_equal_to: 0}
  acts_as_paranoid
end
