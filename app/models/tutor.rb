class Tutor < ActiveRecord::Base
  resourcify
  belongs_to :user
  has_many :practice
  def self.titles
    all.collect{|tutor| [tutor.title, tutor.id]}
  end
end
