class SiteController < ApplicationController
  skip_before_action :check_user_active_time
  skip_authorization_check
  def home
  end

  # 搜索所有课程。
  def search_lesson
    require 'digest/md5'
    @search = params[:title]
    words = Word.where("name LIKE ?", "%" + params[:title] +"%" ).where(is_meanful: true)
    @words = words.order("length")
    @textbooks = Textbook.where("title LIKE ?", "%" + params[:title] +"%")
    @lessons = Lesson.where("title LIKE ?", "%" + params[:title] +"%" )
    @lessons_by_author = Lesson.where("author LIKE ?", "%" + params[:title] +"%" )
    @sentences = []
    search_md = Digest::MD5.hexdigest(@search).bytes.map{|b|b=b-38}.join
    word = Word.find_by(md1: search_md[0..7], md2: search_md[8..15], md3: search_md[16..23], md4: search_md[24..31], md5: search_md[32..39], md6: search_md[40..47], md7: search_md[48..55], md8: search_md[56..63])
    if word
    word.word_parsers.select(:sentence_id).uniq.each{ |w|
      s = Sentence.find_by(id: w.sentence_id)
      if s
        @sentences << s
      end
    }
    elsif @lessons.any?
    else
      redirect_to :back, notice: "暂时没有找到包含 #{@search} 的课文。"
    end
  end

end
