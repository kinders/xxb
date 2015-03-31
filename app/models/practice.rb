class Practice < ActiveRecord::Base
  rolify
  belongs_to :user
  belongs_to :tutor
  belongs_to :lesson
end
