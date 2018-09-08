class Tutor < ApplicationRecord
  resourcify
  belongs_to :user
  belongs_to :lesson
  has_many :practices, dependent: :destroy
  has_many :exercises, dependent: :destroy
  has_attached_file :picture1
  has_attached_file :picture2
  validates_attachment_file_name :picture1, :matches => [/png\Z/, /jpe?g\Z/]
  validates_attachment_content_type :picture1, :content_type => /\Aimage\/.*\Z/
  validates_attachment_file_name :picture2, :matches => [/png\Z/, /jpe?g\Z/]
  validates_attachment_content_type :picture2, :content_type => /\Aimage\/.*\Z/

  acts_as_paranoid
  validates :title, :difficulty, presence: true

=begin
  # 从旧的sqlite数据库中快速复制辅导页面。
  def self.copy_from_xxb_from_sqlite(lesson_id, begin_id, end_id = nil)
    require 'pg'
    tutor_begin_id = begin_id
    if end_id
      tutor_end_id = end_id
    else
      tutor_end_id = tutor_begin_id
    end
    @lesson_id = lesson_id
    tutor_begin_id.upto(tutor_end_id) do |tutor_id|
      conn = PG.connect(dbname: 'xxb_from_sqlite')
      old_record = conn.exec("SELECT * FROM tutors WHERE id=#{tutor_id}")
      Tutor.create(title: old_record.field_values('title')[0], page: old_record.field_values('page')[0], lesson_id: @lesson_id, difficulty: old_record.field_values('difficulty')[0], user_id: 2, proviso: old_record.field_values('proviso')[0], page_length: old_record.field_values('page_length')[0])
      old_record = nil
      conn.finish
    end
  end
=end
end
