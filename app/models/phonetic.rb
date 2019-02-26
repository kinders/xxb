class Phonetic < ApplicationRecord
  has_many :phonetic_notations
  has_many :words, through: :phonetic_notations
  acts_as_paranoid
  validates :content, :label,  presence: true

=begin
  # 去除重复的音标。
  def self.delete_same_phonetics
    1.upto(238267).each do |i|
      current_p = Phonetic.find_by(id: i)
      next unless current_p
      other_p = Phonetic.where(content: current_p.content).where.not(id: i).pluck(:id)
      next if other_p.blank?
      PhoneticNotation.where(phonetic_id: other_p).update_all(phonetic_id: i)
      Phonetic.where(id: other_p).destroy_all
    end
  end
=end

  # 将部分错误音标进行更正，一般是ui和iu的声调
  def self.update_some_content
    wrong_pattern = aōaò"nuè" #"ìong" "ū: ǐan aì ō ɑ
    right_pattern = āoào"nüè" #"iòng" "ǖ" iǎn ài ü a
    Phonetic.where(id: 2273..163202).where("content LIKE ?", "%" + wrong_pattern + "%").each do | phonetic |
      p_content = phonetic.content.gsub(wrong_pattern, right_pattern)
      phonetic.update(content: p_content)
    end
  end

  # 截取最后一个音节作为韵脚
  def self.get_rhyme_for_2273_163202
    162017.upto(163202) do |i|
      phonetic = Phonetic.find_by(id: i)
      next unless phonetic
      yinjie = phonetic.content.split()
      last_yinjie = ""
      if yinjie[-1] == "r"
        last_yinjie = yinjie[-2]
      else
        last_yinjie = yinjie[-1]
      end
      this_rhyme = Phonetic.find_by(content: last_yinjie).rhyme
      phonetic.update(rhyme: this_rhyme)
    end
  end

end
