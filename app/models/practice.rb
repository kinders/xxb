class Practice < ActiveRecord::Base
  resourcify
  belongs_to :user
  belongs_to :tutor
  belongs_to :lesson
end
