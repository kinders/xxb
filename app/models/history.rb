class History < ActiveRecord::Base
  resourcify
  belongs_to :user
end
