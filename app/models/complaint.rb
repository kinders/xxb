class Complaint < ActiveRecord::Base
  belongs_to :user
  resourcify
  acts_as_paranoid

  has_attached_file :picture
  validates_attachment_file_name :picture, :matches => [/png\Z/, /jpe?g\Z/]
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/

  validates :user_id, :content, :url, presence: true
end
