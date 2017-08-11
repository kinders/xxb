class Lesson < ActiveRecord::Base
  resourcify
  belongs_to :user
  has_many :catalogs
  has_many :textbook
  has_many :teachings
  has_many :tutors
  has_many :practices
  has_many :cardboxes
  has_many :word_parsers
  has_many :words, through: :word_parsers
  has_one :words_report
  has_many :sentences
  has_many :paces
  has_many :comments
  has_many :lesson_practices
  has_many :practices, through: :lesson_practices

  def self.titles
    all.collect{|lesson| [lesson.title, lesson.id]}
  end

  has_attached_file :picture
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/
  validates_attachment_file_name :picture, matches: [/png\Z/, /jpe?g\Z/]

  acts_as_paranoid

  validates :title, presence: true
  validates :time, numericality: { only_integer: true }, allow_nil: true
  # validates :content, presence: true if "picture_file_name.nil"
  
  def funky_method
    "#{self.id} #{self.title}"
  end
  
end
