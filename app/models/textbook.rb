class Textbook < ActiveRecord::Base
  resourcify
  belongs_to :user
end
