class Plan < ActiveRecord::Base
  resourcify
  belongs_to :user
  belongs_to :teaching
  belongs_to :tutor
end
