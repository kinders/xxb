class Word < ApplicationRecord
  has_many :word_parsers
  has_many :practice_parsers
  has_many :lessons, through: :word_parsers
  has_many :phonetic_notations
  has_many :phonetics, through: :phonetic_notations
  has_many :meanings
  has_many :comments
  has_many :wordorders
  acts_as_paranoid
  validates :name, :length,  presence: true

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

  # 这个方法可以从百度词典里面获取英语单词的发音和含义
  def load_explain_from_baidu_dict
    require 'net/http'
    require 'nokogiri'

    @word = self

    path = "/s?wd=" + @word.name
    response = Net::HTTP.get_response("dict.baidu.com", path)
    if response.body =~ /id="empty-tip"/
      return
    end

    doc = Nokogiri::HTML(response.body)

    odd = []
    even = []
    doc.css("div#pinyin").inner_html.scan(/\[[^]]*\]/).each_with_index do |item, index|
      if (index & 1) == 0
        odd << item.gsub(/["\[\]]/, "")
      else
        even << item.gsub(/["\[\]]/, "")
      end
    end
    pinyin = even.zip(odd)
    pinyin.each do |py|
      the_phonetic = Phonetic.find_by(content: py[0], label: py[1])
      unless the_phonetic
        the_phonetic = Phonetic.create(content: py[0], label: py[1])
      end
      @word.phonetic_notations.create(phonetic_id: the_phonetic.id)
    end

    a_pattern = Regexp.union(/<a[^>]*>/, /<\/a>/)
    b_pattern = /<b[^>]*>/
    h_pattern = Regexp.union(/<h[^>]*>/, /<\/h[^>]*>/)
    explains = ""
    explains << doc.css("div.en-content","div.tab-content", "div#baike-wrapper")[0].inner_html.gsub(a_pattern, " ").gsub(b_pattern, "<b>").gsub(h_pattern, "") + "<hr>"
    @word.meanings.create(content: explains)

    if @word.name =~ /[A-Z]/
      little_word = @word.name.downcase
      path = "/s?wd=" + little_word
      response = Net::HTTP.get_response("dict.baidu.com", path)
      doc = Nokogiri::HTML(response.body)
      explains = "<div><strong>小写：#{little_word}<strong></div>"
      explains << "<div><strong>音标</strong>"
      explains << doc.css("div#pinyin").inner_html.scan(/\[[^]]*\]/).to_s.gsub(/"/, "")
      explains << "</div>"
      explains << doc.css("div.en-content","div.tab-content", "div#baike-wrapper")[0].inner_html.gsub(a_pattern, " ").gsub(b_pattern, "<b>").gsub(h_pattern, "") + "<hr>"
      @word.meanings.create(content: explains)
    end
  end

  # 这个方法可以从有道词典里面获取英语单词的发音和含义
  def load_explain_from_youdao_dict
    require 'net/http'
    require 'nokogiri'

    @word = self

    path = "/w/" + @word.name
    response = Net::HTTP.get_response("dict.youdao.com", path)
    # if response.body =~ /div class="error-typo"/
      # return
    # end

    doc = Nokogiri::HTML(response.body)

    pinyin = []
    pronounce = doc.css("div#phrsListTab span.pronounce")
    pronounce.each do |p|
      pinyin << [p.css("span.phonetic").inner_html.gsub(/[\[\]]/,""), p.inner_html[0]]
    end
    pinyin.each do |py|
      the_phonetic = Phonetic.find_by(content: py[0], label: py[1])
      unless the_phonetic
        the_phonetic = Phonetic.create(content: py[0], label: py[1])
      end
      @word.phonetic_notations.create(phonetic_id: the_phonetic.id)
    end

    explains = doc.css("div#phrsListTab div.trans-container").inner_html.gsub(/(\n)|(\r)| /, '')
    @word.meanings.create(content: explains)
=begin
    if @word.name =~ /[A-Z]/
      little_word = @word.name.downcase
      path = "/w/" + little_word
      response = Net::HTTP.get_response("dict.youdao.com", path)
      doc = Nokogiri::HTML(response.body)
      explains = "<div><strong>小写：#{little_word}<strong></div><div>"
      explains << doc.css("div#phrsListTab div.trans-container").inner_html.gsub(/(\n)|(\r)| /, '')
      explains << "</div>"
      @word.meanings.create(content: explains)
    end
=end
  end

#=begin
  # 这个类方法可以解决词语包含的问题。
  def self.find_words_in_word(start_id, end_id)
    Word.where(id: start_id..end_id).each do | word|
    logger.info("begin find words in word " + word.id.to_s)
      next unless  /[\u4e00-\u9fa5]/  =~ word.name # 只有词语包含了中文才进行分析
      words_has_word_id = Word.where("name LIKE ?", "%" + word.name + "%" ).pluck(:id)
      words_has_word_id.each do |word_id|
        next if word_id == word.id
        this_word = Word.find(word_id)
        if this_word.include_words_id.blank?
          this_word.update(include_words_id: word.id.to_s)
        else
          this_word_include = this_word.include_words_id + "," + word.id.to_s
          this_word.update(include_words_id: this_word_include)
        end
      end
    logger.info("finish find words in word " + word.id.to_s)
    end
    logger.info('完成分析')
  end
#=end

#=begin
  # 这个类方法补齐md5字段
  def self.add_md5
    require 'digest/md5'
    words = Word.where(md1: nil)
    words.each do |word|
      word_md5 = Digest::MD5.hexdigest(word.name).bytes.map{|b|b=b-38}.join
      word.update(md1: word_md5[0..7], md2: word_md5[8..15], md3: word_md5[16..23], md4: word_md5[24..31], md5: word_md5[32..39], md6: word_md5[40..47], md7: word_md5[48..55], md8: word_md5[56..63])
    end
  end
#=end

=begin
  # 这个方法用来清洗一些符号转义错误: 
  def self.correct_wrong_words(wrong_pattern, right_pattern)
    require 'digest/md5'
    Word.where("name LIKE ?", "%" + wrong_pattern + "%").each do |word|
      new_name = word.name.gsub(/wrong_pattern/, right_pattern)
      same_word = Word.find_by(name: new_name)
      if same_word
        word.word_parsers.update_all(word_id: same_word.id)
        word.destroy
      else
        word_md5 = Digest::MD5.hexdigest(new_name).bytes.map{|b|b=b-38}.join
        word.update(name: new_name, length: new_name.size, md1: word_md5[0..7], md2: word_md5[8..15], md3: word_md5[16..23], md4: word_md5[24..31], md5: word_md5[32..39], md6: word_md5[40..47], md7: word_md5[48..55], md8: word_md5[56..63])
      end
    end
  end
=end


end
