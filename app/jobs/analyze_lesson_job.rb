class AnalyzeLessonJob < ActiveJob::Base
  queue_as :default

  def perform(lesson_id)
    require 'digest/md5'
    # begin
    # 检查是否空白内容
    @lesson = Lesson.find_by(id: lesson_id)
    return unless @lesson
    if @lesson.content == ""
        return "该课程内容为空，无需分析"
    end
    lesson_title = @lesson.title.gsub(/[《》<>()（）]/, "")
    if @lesson.author
    lesson_author = @lesson.author.gsub(/[\[\]《》<>()（）]/, "")
    else
    lesson_author = ""
    end
    content = lesson_title + "。" + lesson_author + "。"+ @lesson.content
    # 获取并精简文本
    content.gsub!(/(<\/h\d>)|(<\/p>)|(<\/div>)/, ".") # 补充句号到段落结尾，防止取出标签之后因为末尾没有标点而和第二行合并
    content.gsub!(/<(\w|\/)+[^>]*>/, "") # 除去html标签
    content.gsub!(/\r|\n|\f/, ".") # 除去换行符，也是防止因为末尾没有标点而和第二行合并
    new_md = Digest::MD5.hexdigest(content)

    # 检查是否存在分析报告，若有则分析文本是否改动
    @words_report = WordsReport.find_by(lesson_id: @lesson.id)
    if @words_report
      if new_md == @words_report.md
        return "别惊讶，这篇课文已经分析过了。"
      else
        @lesson.word_parsers.destroy_all
        @lesson.sentences.destroy_all
        @words_report.destroy
        @words_report = WordsReport.create(lesson_id: @lesson.id, md: new_md)
      end
    else
      @words_report = WordsReport.create(lesson_id: @lesson.id, md: new_md)
    end

# =begin
    # 将括号里的语句提出来，单独作为一句附在内容之后。
    i = 1
    while  match_data = /[(（\[【].+?[)）\]】]/.match(content)
      content.sub!(/[(（\[【].+?[)）\]】]/, "") # 删除第一个括号里的内容。
      another_sentence = match_data.to_s.gsub(/[()（）【】\[\]]/, "") # 清除括号
      content << another_sentence + "。" # 添加到原有内容之后
      i = i + 1
    end
    # p content
# =end
    
    # 处理ckeditor的html转义
    content.gsub!(/(&#39;)/, "'") # 转为原型：单引号
    content.gsub!(/(&ldquo;)/, "“") # 转为原型：“
    content.gsub!(/(&rdquo;)/, "”") # 转为原型：”
    content.gsub!(/(&nbsp;)/, " ") # 转为原型：空格
    content.gsub!(/(&lt;)/, "<") # 转为原型：小于号
    content.gsub!(/(&gt;)/, ">") # 转为原型：大于号
    content.gsub!(/(&aacute;)/, "á") # 转为原型：
    content.gsub!(/(&oacute;)/, "ó") # 转为原型：
    content.gsub!(/(&eacute;)/, "é") # 转为原型：
    content.gsub!(/(&iacute;)/, "í") # 转为原型：
    content.gsub!(/(&uacute;)/, "ú") # 转为原型：
    content.gsub!(/(&agrave;)/, "à") # 转为原型：
    content.gsub!(/(&ograve;)/, "ò") # 转为原型：
    content.gsub!(/(&egrave;)/, "è") # 转为原型：
    content.gsub!(/(&igrave;)/, "ì") # 转为原型：
    content.gsub!(/(&ugrave;)/, "ù") # 转为原型：
    content.gsub!(/(&uuml;)/, "ü") # 转为原型：
    content.gsub!(/(&aelig;)/, "æ") # 转为原型：
    content.gsub!(/(&theta;)/, "θ") # 转为原型：
    content.gsub!(/(&eth;)/, "ð") # 转为原型：

    # 将内容分割为句子，逐句分析
    sentences = content.split(/[，；。？！……——：,;.?!:]/)
    # sentences = content.split(/[，；。？！……——：]|([,;.?!:] )/)
    sentences.each do |sentence|
      word_parser = []
      ## 将句子中的引号去除
      sentence.gsub!(/(?<=[a-zA-Z])'(?=[a-zA-Z])/, "。") # 将两个单词中间的单引号转义，防止被删除
      sentence.gsub!(/['"“”‘’]/, "")
      sentence.gsub!(/。/, "'") # 转为原型：单引号
      # next if sentence =~ /[,.?!:]/
      # next if sentence =~ /[,.?!:] /
      @sentence = Sentence.create(lesson_id: @lesson.id, name: sentence)
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
          # word = Word.find_by(name: words_with_blank)
          word = Word.find_by(md1: words_with_blank_id[0..7], md2: words_with_blank_id[8..15], md3: words_with_blank_id[16..23], md4: words_with_blank_id[24..31], md5: words_with_blank_id[32..39], md6: words_with_blank_id[40..47], md7: words_with_blank_id[48..55], md8: words_with_blank_id[56..63])
          if word
            @word = word
          elsif words_length == 1
            # @word = Word.create(name: words_with_blank, length: words_length)
            @word = Word.create(name: words_with_blank, length: words_length, md1: words_with_blank_id[0..7], md2: words_with_blank_id[8..15], md3: words_with_blank_id[16..23], md4: words_with_blank_id[24..31], md5: words_with_blank_id[32..39], md6: words_with_blank_id[40..47], md7: words_with_blank_id[48..55], md8: words_with_blank_id[56..63], is_meanful: true)
            GetWordExplainJob.perform_later @word.id
          else
            # @word = Word.create(name: words_with_blank, length: words_length)
            @word = Word.create(name: words_with_blank, length: words_length, md1: words_with_blank_id[0..7], md2: words_with_blank_id[8..15], md3: words_with_blank_id[16..23], md4: words_with_blank_id[24..31], md5: words_with_blank_id[32..39], md6: words_with_blank_id[40..47], md7: words_with_blank_id[48..55], md8: words_with_blank_id[56..63])
          end
          #### 登记本个用词分析
          # word_parser = WordParser.create(lesson_id: @lesson.id, sentence_id: @sentence.id, word_id: @word.id)
          word_parser << {lesson_id: @lesson.id, sentence_id: @sentence.id, word_id: @word.id}
        end
        a_size = a_size - 1
      end
      WordParser.create(word_parser)
    end
=begin
    rescue
      @lesson.word_parsers.destroy_all
      @lesson.sentences.destroy_all
      @words_report.destroy
        return "对课文解析出错。"
    end
=end
  end

end
