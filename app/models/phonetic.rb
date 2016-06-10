class Phonetic < ActiveRecord::Base
  has_many :phonetic_notations
  has_many :words, through: :phonetic_notations
  acts_as_paranoid
  validates :content,  presence: true
end
