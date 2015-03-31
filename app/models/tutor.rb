class Tutor < ActiveRecord::Base
  rolify
  belongs_to :user
  has_many :practice
end
