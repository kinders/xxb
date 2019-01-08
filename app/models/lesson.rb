class Lesson < ApplicationRecord
  resourcify
  belongs_to :user
  has_many :catalogs
  has_many :textbook
  has_many :teachings
  has_many :tutors
  has_many :practices
  has_many :cardboxes
  has_many :word_parsers
  has_many :words, through: :word_parsers
  has_one :words_report
  has_many :sentences
  has_many :paces
  has_many :comments
  has_many :lesson_practices
  has_many :practices, through: :lesson_practices

  def self.titles
    all.collect{|lesson| [lesson.title, lesson.id]}
  end

  has_attached_file :picture
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/
  validates_attachment_file_name :picture, matches: [/png\Z/, /jpe?g\Z/]

  acts_as_paranoid

  validates :title, presence: true
  validates :time, numericality: { only_integer: true }, allow_nil: true
  # validates :content, presence: true if "picture_file_name.nil"
  
  def funky_method
    "#{self.id} #{self.title}"
  end

# =begin
  def self.get_lesson_from_gsc
    require 'open-uri'
    require 'nokogiri'
    lesson_id = 16030
    num = (6578..6707)
    # num = [995..1054]
    num.each do |n|
      puts n
      if [16040, 16061,16132].include?(lesson_id)
        lesson_id = lesson_id + 1
      end
      lesson = Lesson.find(lesson_id)
      puts lesson.title
      path = "https://so.gushiwen.org/guwen/bookv_" + n.to_s + '.aspx'
      puts path
      page = Nokogiri::HTML(open(path))
      content = page.css('div.contson').inner_html
      content.gsub!(/　　/, "")
      # content.gsub!(/<a[^>]*>/, "")
      # content.gsub!(/<\/a>/, "")
      # content.gsub!(/　　[①-⑩][^　]*\r\n\r\n/, "")
      # content.gsub!(/[①-⑩]/, "")
      # content.gsub!(/\r\n\r\n　　/, "<p>")
      # content.gsub!(/——/, "。")
      # puts content
      if content == ""
        puts "lesson_id:" + lesson_id.to_s
        puts "lesson_title:" + lesson.title
        puts "num:" + n.to_s
        exit
      end
      content_length = content.gsub(/(<(\w|\/)+[^>]*>|\s)/, "").length
      lesson.update(content: content, content_length: content_length)
      lesson_id = lesson_id + 1
    end
  end
# =end

# =begin
  def self.get_lesson_from_syep
    require 'open-uri'
    require 'nokogiri'
    lesson_id = 15438
    num = [583, 581, 579, 577, 573, 571, 569, 567, 567, 563, 555, 553, 551, 549, 547, 544, 542, 540, 538, 536, 527, 519, 513, 511, 509, 507, 505, 503, 501, 499, 497, 495, 493, 491, 489, 487, 485, 483, 481]
    num.each do |n|
      puts n
      lesson = Lesson.find(lesson_id)
      puts lesson.title
      path = "http://www.sanyanerpai.com/?p=" + n.to_s
      puts path
      page = Nokogiri::HTML(open(path))
      content = page.css('div.entry').inner_html
      puts content
      exit unless content
      content_length = content.gsub(/(<(\w|\/)+[^>]*>|\s)/, "").length
      lesson.update(content: content, content_length: content_length)
      lesson_id = lesson_id + 1
    end
  end
# =end


# =begin
  def self.get_lesson_from_guoxue
    num = 3
    directory = "public/data_import"
    Lesson.where(id: 20944..21043).each do |lesson|
      # next if [18997, 19794, 19803, 19829, 19830, 19831, 19832, 19839, 19851].include?(lesson.id)
      name = num.to_s.rjust(3, "0") + ".htm"
      # name = "cs_" + num.to_s.rjust(3, "0") + ".htm"
      path = File.join(directory, name)
      content = ""
      IO.foreach(path) do |line|
        content << line
      end
      # next unless contents
      if content == ""
        puts "lesson_id:" + lesson.id.to_s
        puts "lesson_title:" + lesson.title
        puts "num:" + num.to_s
        exit
      end
      content_length = content.gsub(/(<(\w|\/)+[^>]*>|\s)/, "").length
      lesson.update(content: content, content_length: content_length)
      num = num + 1
    end
  end
# =end

# =begin
  def self.get_lesson_from_ctext
    require 'open-uri'
    require 'nokogiri'
    laiyuan = ["bie-tong", "chao-qi", "zhuang-liu", "han-wen", "qian-gao", "bian-dong", "ming-yu", "shun-gu", "luan-long", "zao-hu", "shang-chong", "jiang-rui", "zhi-rui", "shi-ying", "zhi-qi", "zi-ran", "gan-lei", "qi-shi", "xuan-han", "hui-guo", "yan-fu", "xu-song", "yi-wen", "lun-si", "si-wei", "ji-yao", "ding-gui", "yan-du", "bo-zang", "si-hui", "shi", "ji-ri", "bu-shi", "bian-sui", "nan-sui", "jie-shu", "jie-chu", "si-yi", "ji-yi", "shi-zhi", "zhi-shi", "ding-xian", "zheng-shuo", "shu-jie", "an-shu", "dui-zuo", "zi-ji"]
    num = 44
    Lesson.where(id: 20094..20096).each do |lesson|
      next if [20055].include?(lesson.id)
      # path = "https://ctext.org/wei-liao-zi/" + num.to_s + "/zhs"
      path = "https://ctext.org/lunheng/" + laiyuan[num] + "/zhs"
      page = Nokogiri::HTML(open(path))
      contents = page.css("td.ctext")
      content = ""
      contents.each_with_index do | item, index |
        next if index.even?
        content << "<p>"
        content << item.inner_text
        content << "</p>"
      end
      if content == ""
        puts lesson.id.to_s
        puts laiyuan[num]
        puts num
        exit
      end
      content_length = content.gsub(/(<(\w|\/)+[^>]*>|\s)/, "").length
      lesson.update(content: content, content_length: content_length)
      num = num + 1
    end
  end
# =end
  
# =begin
  def self.update_content_length
    Lesson.where(id: 20373..20477).each do |lesson|
      next unless lesson.content
      content_length = lesson.content.gsub(/(<(\w|\/)+[^>]*>|\s)/, "").length
      lesson.update(content_length: content_length)
    end
  end
# =end

# =begin
  def self.update_content
    Lesson.where(id: 16030..16162).each do |lesson|
      next unless lesson.content
      content = lesson.content.gsub(/\s/, "")
      # content = lesson.content.gsub(/　/, "")
      #content = content.sub(/<p>$/, "")
      lesson.update(content: content)
    end
  end


end
