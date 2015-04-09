class Evaluation < ActiveRecord::Base
  resourcify
  belongs_to :user
  belongs_to :tutor
  belongs_to :practice
end
