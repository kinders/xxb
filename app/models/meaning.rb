class Meaning < ActiveRecord::Base
  belongs_to :word
  acts_as_paranoid
  validates :content,  presence: true
end
