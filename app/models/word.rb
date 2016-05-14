class Word < ActiveRecord::Base
  has_many :word_parsers
  acts_as_paranoid
  validates :name, :length,  presence: true
end
