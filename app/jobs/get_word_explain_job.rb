class GetWordExplainJob < ActiveJob::Base
  queue_as :default

  def perform(word_id)

    @word = Word.find(word_id)

    if @word =~ /\w/   # 如果包含了英语字母，就在百度词典里面查找
      @word.load_explain_from_baidu_dict
    else               # 如果没有包含英语字母，就在百度汉语里面查找
      @word.load_explain_from_baidu_hanyu
    end
  end
end
