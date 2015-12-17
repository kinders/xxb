class Lesson < ActiveRecord::Base
  resourcify
  belongs_to :user
  has_many :catalogs, dependent: :destroy
  has_many :teachings, dependent: :destroy
  has_many :tutors, dependent: :destroy
  has_many :practices, dependent: :destroy
  has_many :cardboxes, dependent: :destroy

  def self.titles
    all.collect{|lesson| [lesson.title, lesson.id]}
  end

  has_attached_file :picture
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/
  validates_attachment_file_name :picture, matches: [/png\Z/, /jpe?g\Z/]

  acts_as_paranoid

  validates :title, presence: true
  # validates :content, presence: true if "picture_file_name.nil"
  
  def funky_method
    "#{self.id} #{self.title}"
  end
  
end
