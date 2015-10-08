class Practice < ActiveRecord::Base
  resourcify
  belongs_to :user
  belongs_to :tutor
  belongs_to :lesson
  has_many :evaluations, dependent: :destroy
  has_many :justices, dependent: :destroy
  has_many :exercises, dependent: :destroy
  has_many :cards, dependent: :destroy

  has_attached_file :picture_q
  validates_attachment_file_name :picture_q, :matches => [/png\Z/, /jpe?g\Z/]
  validates_attachment_content_type :picture_q, :content_type => /\Aimage\/.*\Z/
  has_attached_file :picture_a
  validates_attachment_file_name :picture_a, :matches => [/png\Z/, /jpe?g\Z/]
  validates_attachment_content_type :picture_a, :content_type => /\Aimage\/.*\Z/

  acts_as_paranoid
  validates :title, :lesson_id, presence: true
end
