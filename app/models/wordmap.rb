class Wordmap < ActiveRecord::Base
  belongs_to :user
  belongs_to :roadmap
  has_many :wordorders
  acts_as_paranoid
  validates :user_id, :roadmap_id, :name,  presence: true
end
# user_id：references	属于一个用户
# roadmap_id: references	属于一个文路
# name: string	名称
# deleted_at: datetime	假删除

