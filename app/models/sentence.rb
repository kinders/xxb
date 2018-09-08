class Sentence < ApplicationRecord
  belongs_to :lesson
  has_many :word_parsers
  has_many :words, through: :word_parsers
  has_many :comments
  acts_as_paranoid
  validates :name, :lesson_id, presence: true

=begin
  # 将包含破折号和省略号的句子进行拆分，重新分析，然后删除包含这两种符号的word
  def refund_sentence
    Sentences.where("name LIKE ?", "%&hellip;%").each do |sentence|
      
    end
  end

  # 找出没有分析的句子
  def self.find_and_analysis
    Sentence.find_each do |sentence|
      next unless sentence.word_parsers.empty?
      AnalyzeSentenceJob.perform_later sentence.id
    end
  end

  # 找到包含？的句子并重新划分
  def self.refind_wrong_sentence
    wrongs = Sentence.where('name LIKE ?', '%?%')
    wrongs.each {|wrong|
      old_name = wrong.name
      old_lesson = wrong.lesson_id
      old_name.split("?").each{|new_name|
        Sentence.create(lesson_id: old_lesson, name: new_name)
      }
      wrong.destroy
    }
  end
=end

end
