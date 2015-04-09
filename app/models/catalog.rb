class Catalog < ActiveRecord::Base
  resourcify
  belongs_to :user
  belongs_to :textbook
  belongs_to :lesson
end
