class AnalyzeSentenceJob < ActiveJob::Base
  queue_as :default

  def perform(sentence_id, lesson_id)
    require 'digest/md5'
    @sentence = Sentence.find_by(id: sentence_id)
    @lesson = Lesson.find_by(id: lesson_id)
    return unless @sentence
    return unless @lesson
    word_parser = []
    sentence = @sentence.name
    ## 将句子中的非中文字符用空格隔开
    chinese_pattern = /[\u4e00-\u9fa5]/
    none_chinese_part = sentence.split(chinese_pattern).delete_if{|x| x == ""}
    none_chinese_part.each do |p|
      next unless p
      sentence.gsub!(/#{p}/, " "+p+" ").squeeze(" ")
    end
    ## 将句子分隔为词语
    words = sentence.split(/\s+/).delete_if {|w| w == ""}
    real_words = []
    words.each do |word|   # 逐个词语分析
      unless chinese_pattern.match(word)
        real_words << word
      else
        letters = word.chars
        real_words << letters
      end
    end
    real_words.flatten!
    ## 正式对句子中的单词进行解析。
    a_size = real_words.size
    a_size.times do |i|
      a_size.times do |j|
        words_with_blank =  real_words[i, j+1].join(" ")
        words_with_blank.gsub!(/(?<=[\u4e00-\u9fa5]) (?=[\u4e00-\u9fa5])/, "") #去除中文中间多余的空格
        # p words_with_blank
        ### 至此完成拆分成最小单位
        ### 计算字符串的md值作为索引
        words_with_blank_id = Digest::MD5.hexdigest(words_with_blank).bytes.map{|b|b=b-38}.join
        
        ### 下面计算单位的长度，有中文则按字计算，非中文按空格计算
        if words_with_blank =~ /[\u4e00-\u9fa5]/
          words_length = words_with_blank.size
        else
          words_length = words_with_blank.split(" ").size
        end
        #### 查找单词，找不到时创建word记录
        word = Word.find_by(md1: words_with_blank_id[0..7], md2: words_with_blank_id[8..15], md3: words_with_blank_id[16..23], md4: words_with_blank_id[24..31], md5: words_with_blank_id[32..39], md6: words_with_blank_id[40..47], md7: words_with_blank_id[48..55], md8: words_with_blank_id[56..63])
        if word
          @word = word
        elsif words_length == 1
          @word = Word.create(name: words_with_blank, length: words_length, md1: words_with_blank_id[0..7], md2: words_with_blank_id[8..15], md3: words_with_blank_id[16..23], md4: words_with_blank_id[24..31], md5: words_with_blank_id[32..39], md6: words_with_blank_id[40..47], md7: words_with_blank_id[48..55], md8: words_with_blank_id[56..63], is_meanful: true)
          GetWordExplainJob.perform_later @word.id
        else
          @word = Word.create(name: words_with_blank, length: words_length, md1: words_with_blank_id[0..7], md2: words_with_blank_id[8..15], md3: words_with_blank_id[16..23], md4: words_with_blank_id[24..31], md5: words_with_blank_id[32..39], md6: words_with_blank_id[40..47], md7: words_with_blank_id[48..55], md8: words_with_blank_id[56..63])
        end
        #### 登记本个用词分析
        word_parser << {lesson_id: @lesson.id, sentence_id: @sentence.id, word_id: @word.id}
      end
      a_size = a_size - 1
    end
    WordParser.create(word_parser)
  end
end
