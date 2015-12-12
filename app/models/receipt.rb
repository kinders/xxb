class Receipt < ActiveRecord::Base
  belongs_to :user
  resourcify
  acts_as_paranoid
  validates :user_id, :active_time_before_charge, :money, :time_length, :active_time_after_charge, :cashier, :balance, presence: true
  validates :active_time_after_charge, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :balance, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
