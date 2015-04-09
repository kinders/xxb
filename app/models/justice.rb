class Justice < ActiveRecord::Base
  resourcify
  belongs_to :user
  belongs_to :evaluation
  validates :score, presence: true, numericality: {less_than_or_equal_to: :practice_score, greater_than_or_equal_to: 0}
end
