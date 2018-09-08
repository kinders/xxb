class Wordorder < ApplicationRecord
  belongs_to :user
  belongs_to :wordmap
  belongs_to :word
  acts_as_paranoid
  validates :user_id, :wordmap_id, :word_id, :serial,  presence: true
end
# user_id：references	属于一个用户
# wordmap_id: references	属于一个词序表
# word_id: references	属于一个词语
# serial: integer	词序
# deleted_at: datetime	假删除
