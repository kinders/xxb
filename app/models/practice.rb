class Practice < ActiveRecord::Base
  resourcify
  belongs_to :user
  belongs_to :tutor
  belongs_to :lesson
  has_many :evaluations, dependent: :destroy
  has_many :justices, dependent: :destroy
  has_many :exercises, dependent: :destroy
  has_many :cards, dependent: :destroy
  has_many :quiz_items, dependent: :destroy

  has_attached_file :picture_q
  validates_attachment_file_name :picture_q, :matches => [/png\Z/, /jpe?g\Z/]
  validates_attachment_content_type :picture_q, :content_type => /\Aimage\/.*\Z/
  has_attached_file :picture_a
  validates_attachment_file_name :picture_a, :matches => [/png\Z/, /jpe?g\Z/]
  validates_attachment_content_type :picture_a, :content_type => /\Aimage\/.*\Z/

  acts_as_paranoid
  validates :title, :lesson_id, presence: true
end

=begin
id
title 标题
material 材料
question 问题
labelname 可以废除，没有实际意义
answer 答案
user_id 只有所有者才能修改，但其他人可以将题目给自己重新复制一份后修改
tutor_id  应该废除，改为多对多
lesson_id  应该废除，改为多对多
activate  应该废除，没有实际意义
用图片展示问题, 应该废除，用ckeditor已经解决这个问题
picture_q_file_name
picture_q_content_type
picture_q_file_size
picture_q_updated_at
用图片展示答案， 应该废除，用ckeditor已经解决这个问题
picture_a_file_name
picture_a_content_type
picture_a_file_size
picture_a_updated_at
统计指标
mean  平均分
mode  方差
stdev 标准差
difficulty  难度

created_at
deleted_at
=end
