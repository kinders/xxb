class Tutor < ActiveRecord::Base
  resourcify
  belongs_to :user
  belongs_to :lesson
  has_many :practices
  has_attached_file :picture1
  has_attached_file :picture2
  validates_attachment_file_name :picture1, :matches => [/png\Z/, /jpe?g\Z/]
  validates_attachment_content_type :picture1, :content_type => /\Aimage\/.*\Z/
  validates_attachment_file_name :picture2, :matches => [/png\Z/, /jpe?g\Z/]
  validates_attachment_content_type :picture2, :content_type => /\Aimage\/.*\Z/

  acts_as_paranoid
  validates :title, :difficulty, presence: true
end
