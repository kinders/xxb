class Word < ActiveRecord::Base
  has_many :word_parsers
  has_many :phonetic_notations
  has_many :phonetics, through: :phonetic_notations
  has_many :meanings
  acts_as_paranoid
  validates :name, :length,  presence: true

  def who
    @word = self
    puts @word.name
  end

  # 这个方法专门为了获取单个汉字的注音和词义
  def load_explain_from_baidu_hanyu
    require 'net/http'
    @word = self
    path = "/zici/s?wd=" + @word.name
    response = Net::HTTP.get_response("hanyu.baidu.com", path)
    pinyin = response.body.scan(/<span><b>(.*?)<\/b>/)
    pinyin.each do |py|
      the_phonetic = Phonetic.find_by(content: py)
      unless the_phonetic
        the_phonetic = Phonetic.create(content: py, label: "")
      end
      @word.phonetic_notations.create(phonetic_id: the_phonetic.id)
    end
    number = pinyin.size
    explains = response.body.scan(/<dl>(.*?)<\/dl>/)[0..number-1].join(" ")
    @word.meanings.create(content: explains)
  end

  # 这个方法可以批量获得词义。
  def self.load_explain_from_baidu_hanyu(start_at, end_at)
    require 'net/http'
    require 'nokogiri'

    Word.where(id: start_at..end_at).each do |word|
      next if word.meanings.any?

      path = "/zici/s?wd=" + word.name
      response = Net::HTTP.get_response("hanyu.baidu.com", path)
      next if response.body =~ /id="empty-tip"/

      a_pattern = Regexp.union(/<a[^>]*>/, /<\/a>/)
      b_pattern = /<b[^>]*>/
      h_pattern = Regexp.union(/<h[^>]*>/, /<\/h[^>]*>/)

      explains = ""
      doc = Nokogiri::HTML(response.body)

      explains <<  doc.css("div#pinyin").inner_html.gsub(a_pattern, "").gsub(b_pattern, "<b>").gsub(h_pattern, "")
      if doc.css("b.title","b.active")[0]
      title = doc.css("b.title","b.active")[0].inner_html.gsub(a_pattern, "").gsub(b_pattern, "<b>") 
      explains << "<hr><b>" + title + "</b>" if title
      end
      if doc.css("div.en-content","div.tab-content", "div#baike-wrapper")[0]
      explains << doc.css("div.en-content","div.tab-content", "div#baike-wrapper")[0].inner_html.gsub(a_pattern, " ").gsub(b_pattern, "<b>").gsub(h_pattern, "") + "<hr>"
      end
      explains <<  doc.css("div#baike-wrapper").inner_html.gsub(a_pattern, " ").gsub(b_pattern, "<b>").gsub(h_pattern, "").gsub("查看百科", "")
      word.meanings.create(content: explains) unless explains == ""
    end
  end


end
