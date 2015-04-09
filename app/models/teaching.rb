class Teaching < ActiveRecord::Base
  resourcify
  belongs_to :user
  belongs_to :lesson
end
