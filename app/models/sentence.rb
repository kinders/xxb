class Sentence < ActiveRecord::Base
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
=end

  # 找出没有分析的句子
  def self.find_and_analysis
    Sentence.find_each do |sentence|
      next unless sentence.word_parsers.empty?
      AnalyzeSentenceJob.perform_later sentence.id
    end
  end

end
