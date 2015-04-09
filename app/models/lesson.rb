class Lesson < ActiveRecord::Base
  resourcify
  belongs_to :user
  has_many :tutor
  has_many :practice, through: :tutor
  def self.titles
    all.collect{|lesson| [lesson.title, lesson.id]}
  end
end
