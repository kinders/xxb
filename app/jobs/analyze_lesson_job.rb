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
    # 检查是否存在分析报告，若有则分析文本是否改动
    new_md = Digest::MD5.hexdigest(content)
    @words_report = WordsReport.find_by(lesson_id: @lesson.id)
    old_sentences_id = []
    if @words_report && new_md == @words_report.md
      return "别惊讶，这篇课文已经分析过了。"
    else
      # @lesson.word_parsers.destroy_all
      # @lesson.sentences.destroy_all
      old_sentences_id = @lesson.sentences.pluck(:id)
      @words_report.destroy
    end
    @words_report = WordsReport.create(lesson_id: @lesson.id, md: new_md)

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
    content.gsub!(/(&quot;)/, "'") # 转为原型：单引号
    content.gsub!(/(&ldquo;)/, "“") # 转为原型：“
    content.gsub!(/(&rdquo;)/, "”") # 转为原型：”
    content.gsub!(/(&lsquo;)/, "“") # 转为原型：“
    content.gsub!(/(&rsquo;)/, "”") # 转为原型：”
    content.gsub!(/(&nbsp;)/, " ") # 转为原型：空格
    content.gsub!(/(&lt;)/, "<") # 转为原型：小于号
    content.gsub!(/(&gt;)/, ">") # 转为原型：大于号
    content.gsub!(/(&hellip;)/, '…') # 转为原型：一半省略号
    content.gsub!(/(&mdash;)/, '—') # 转为原型：一半破折号
    content.gsub!(/(&middot;)/, '·') # 转为原型：·
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
    sentences.each do |sentence|
      sentence.gsub!(/(?<=[a-zA-Z])'(?=[a-zA-Z])/, "。") # 将两个单词中间的单引号转义，防止被删除
      sentence.gsub!(/['"“”‘’]/, "") # 将句子中的引号去除
      sentence.gsub!(/。/, "'") # 转为原型：单引号
      @sentence = Sentence.where(lesson_id: @lesson.id, name: sentence)
      if @sentence
        next
      else
        @sentence = Sentence.create(lesson_id: @lesson.id, name: sentence)
        AnalyzeSentenceJob.perform_later @sentence.id
      end
    end
    new_sentences_id = @lesson.sentences.pluck(:id)
    diff_sentences_id = old_sentences_id - new_sentences_id
    Sentence.where(id: diff_sentences_id).destroy_all
=begin  
    rescue
      @lesson.sentences.destroy_all
      @words_report.destroy
        return "对课文解析出错。"
    end
=end
  end

end
