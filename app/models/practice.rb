class Practice < ApplicationRecord
  resourcify
  belongs_to :user
  belongs_to :tutor
  belongs_to :lesson
  has_many :evaluations, dependent: :destroy
  has_many :justices, dependent: :destroy
  has_many :exercises, dependent: :destroy
  has_many :cards, dependent: :destroy
  has_many :quiz_items, dependent: :destroy
  has_many :practice_parsers
  has_many :lesson_practices
  has_many :lessons, through: :lesson_practices

  has_attached_file :picture_q
  validates_attachment_file_name :picture_q, :matches => [/png\Z/, /jpe?g\Z/]
  validates_attachment_content_type :picture_q, :content_type => /\Aimage\/.*\Z/
  has_attached_file :picture_a
  validates_attachment_file_name :picture_a, :matches => [/png\Z/, /jpe?g\Z/]
  validates_attachment_content_type :picture_a, :content_type => /\Aimage\/.*\Z/

  acts_as_paranoid
  validates :question, :answer, presence: true

  # 这个方法对练习题进行分析。
  def analysis_practice
    practice_id = self.id
    practice_content = self.question +  self.answer
    practice_content.gsub!(/<(\w|\/)+[^>]*>/, "") # 除去html标签
    word_part_content =  []

    word_part_content << practice_content.scan(/\w+/)
    word_part_content << practice_content.scan(/[\u4e00-\u9fa5]/)
    word_part_content.flatten!
    word_part_content.uniq!
    word_parsers_params = []
    if self.practice_parsers.empty?
      words_id = Word.where(name: word_part_content).pluck(:id)
      words_id.each{|w| word_parsers_params << {practice_id: practice_id, word_id: w} }
    else
        new_words_id = Word.where(name: word_part_content).pluck(:id)
        old_words_id = PracticeParser.where(practice_id: practice_id).pluck(:word_id)
        bad_words_id = old_words_id - new_words_id
        PracticeParser.where(practice_id: practice_id, word_id: bad_words_id).destroy_all
        good_words_id = new_words_id - old_words_id
        good_words_id.each{|w| word_parsers_params << {practice_id: practice_id, word_id: w} }
    end
    PracticeParser.create(word_parsers_params)
  end

=begin
  # 将practice原来的lesson_id字段迁移到lesson_practice里。
  def self.move_to_lesson_practices
    Practice.find_each do |practice|
      LessonPractice.create(practice_id: practice.id, lesson_id: practice.lesson_id)
    end
  end
=end

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
score 分值
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
