class LessonsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]
  before_action :be_a_master, except: [:index, :show]
  autocomplete :lesson, :title, full: true, :display_value => :funky_method, extra_data: [:id]
  after_action :update_length, only: [:create, :update]

  # GET /lessons
  # GET /lessons.json
  def index
      @lessons = Lesson.all.order("time").page(params[:page]).per("10")
  end

  # GET /lessons_in_content_length
  # GET /lessons.json
  def lessons_in_content_length
      @lessons = Lesson.all.order("content_length").page(params[:page]).per("100")
      render :index
  end

  # GET /lessons/1
  # GET /lessons/1.json
  def show
    # 记录足迹
    history = History.create(user_id: current_user.id, modelname: "lesson", entryid: @lesson.id)
    @catalogs = Catalog.where(lesson_id: @lesson.id)
    if @catalogs.any?
      @textbooks = Textbook.where(id: @catalogs.map{|c| c.textbook_id}.uniq)
    end
    if session[:textbook_id]
      @textbook = Textbook.find_by(id: session[:textbook_id])
      @catalog = Catalog.find_by(textbook_id: @textbook.id, lesson_id: @lesson.id)
      # 生成“前一课”和“后一课”按钮
      all_catalogs = Catalog.where(textbook_id: session[:textbook_id]).order(:serial).pluck(:lesson_id)
      index = all_catalogs.find_index(@lesson.id)
      if index
      if index - 1 < 0
	      @previous_lesson = nil  
	    else
	      previous_catalog = all_catalogs[index - 1]
	      @previous_lesson = Lesson.find(previous_catalog)
	    end
	    if index + 1 == all_catalogs.length
	      @next_lesson = nil
	    else
	      next_catalog = all_catalogs[index + 1]
	      @next_lesson = Lesson.find(next_catalog)
	    end
	    end
    end
    session[:lesson_id] = @lesson.id
    session[:sentence_id] = nil
    session[:tutor_id] = nil
    session[:teaching_id] = nil
    @words_report = WordsReport.find_by(lesson_id: @lesson.id)
    # 标准教学计划
    if session[:discussion_id]
      @discussion = Discussion.find(session[:discussion_id])
      session[:teaching_id] = @discussion.teaching_id
      if  @discussion.lesson_id == @lesson.id
        standard_teaching = Teaching.find(session[:teaching_id])
      else
        standard_teaching = Teaching.find_by(user_id: 2, lesson_id: @lesson.id)
        @discussion_lesson = @discussion.lesson
      end
    else
      standard_teaching = Teaching.find_by(user_id: 2, lesson_id: @lesson.id)
    end
    if standard_teaching
      session[:teaching_id] = standard_teaching.id
      @standard_plan = Plan.where(teaching_id: standard_teaching).order("serial").first
      # 按钮，跳转到标准辅导第一个辅导页面
      if @standard_plan
        @tutor = Tutor.find(@standard_plan.tutor_id)
      end
    end
  end

  # GET /lessons/new
  def new
    @lesson = Lesson.new
    @lesson.user_id = current_user.id
  end

  # GET /lessons/1/edit
  def edit
  end

  # POST /lessons
  # POST /lessons.json
  def create
    @lesson = Lesson.new(lesson_params)
    @lesson.user_id = current_user.id
    # @lesson.content_length = @lesson.content.gsub(/(<(\w|\/)+[^>]*>|\s)/, "").length

    respond_to do |format|
      if @lesson.save
        # AnalyzeLessonJob.perform_later @lesson.id
        format.html { redirect_to @lesson, notice: "该课程\"#{@lesson.title}\"已经添加。" }
        format.json { render :show, status: :created, location: @lesson }
      else
        format.html { render :new }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lessons/1
  # PATCH/PUT /lessons/1.json
  def update
    respond_to do |format|
      if @lesson.update(lesson_params)
        # @lesson.content_length = @lesson.content.gsub(/(<(\w|\/)+[^>]*>|\s)/, "").length
        @lesson.save
        # AnalyzeLessonJob.perform_later @lesson.id
        format.html { redirect_to @lesson, notice: "课程\"#{@lesson.title}\"已经更新完毕。" }
        format.json { render :show, status: :ok, location: @lesson }
      else
        format.html { render :edit }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lessons/1
  # DELETE /lessons/1.json
  def destroy
    @lesson.destroy
    respond_to do |format|
      format.html { redirect_to lessons_url, notice: "课程\"#{@lesson.title}\"已经被成功删除。" }
      format.json { head :no_content }
    end
  end

  def delete_picture
    @lesson = Lesson.find(session[:lesson_id])
    @lesson.picture = nil
    @lesson.save
    respond_to do |format|
      format.html { redirect_to :back, notice: "图片已经被删除" }
      format.json { head :no_content }
    end
  end

  # 快速将所有辅导页面组织成教法。
  def easy_teaching
    @lesson = Lesson.find(params[:lesson_id])
    teaching = Teaching.create { |t|
      t.user_id = current_user.id
      t.lesson_id = @lesson.id
      t.title = "简易教法" + Time.now.strftime("%F %T")
    }
    @lesson.tutors.order(:difficulty).each_with_index { |tutor, index|
      plan = Plan.create { |p|
        p.user_id = current_user.id
        p.teaching_id = teaching.id
        p.tutor_id = tutor.id
        p.serial = index
      }
    }
    redirect_to :back, notice: "#{teaching.title}已经成功创建。"
  end


  # 分析课文正文
  # GET /lessons/1/words_analysis
  def words_analysis
# =begin
    if params[:lesson_id]
      AnalyzeLessonJob.perform_later params[:lesson_id]
      redirect_to :back, notice: "已经将分析任务提交给后台，分析需要较长时间，请耐心等候。"
    else
      redirect_to :back, notice: "没有找到所要分析的课程"
    end
# =end
=begin
    require 'digest/md5'
    begin
    # 检查是否空白内容
    @lesson = Lesson.find(session[:lesson_id])
    if @lesson.content == ""
        redirect_to :back, notice: "该课程内容为空，无需分析"
        return
    end
    content = @lesson.title + "。" + (@lesson.author || "") + "。"+ (@lesson.content || "")
    # 获取并精简文本
    content.gsub!(/<(\w|\/)+[^>]*>/, "") # 除去html标签
    content.gsub!(/\r|\n|\f/, "") # 除去换行符
    new_md = Digest::MD5.hexdigest(content)

    # 检查是否存在分析报告，若有则分析文本是否改动
    @words_report = WordsReport.find_by(lesson_id: @lesson.id)
    if @words_report
      if new_md == @words_report.md
        redirect_to words_report_url(@words_report), notice: "别惊讶，这篇课文已经分析过了。"
        return
      else
        @lesson.word_parsers.destroy_all
        @lesson.sentences.destroy_all
        @words_report.destroy
        @words_report = WordsReport.create(lesson_id: @lesson.id, md: new_md)
      end
    else
      @words_report = WordsReport.create(lesson_id: @lesson.id, md: new_md)
    end

    @begin_at = Time.now

    # 将括号里的语句提出来，单独作为一句附在内容之后。
    # 当然如果是括号里还有括号这种写法，下面的分析会出错。可是谁让那个人乱写呢？
    i = 1
    while  match_data = /[(（\[【].+?[)）\]】]/.match(content)
      content.sub!(/[(（\[【].+?[)）\]】]/, "") # 删除第一个括号里的内容。
      another_sentence = match_data.to_s.gsub(/[()（）【】\[\]]/, "") # 清除括号
      content << another_sentence + "。" # 添加到原有内容之后
      i = i + 1
    end
    # p content
    
    # 将内容分割为句子，逐句分析
    sentences = content.split(/[，；。？！……——：]|([,;.?!:] )/)
    sentences.each do |sentence|
      word_parser = []
      ## 将句子中的引号去除
      sentence.gsub!(/['"“”]/, "")
      sentence.gsub!(/&rdquo;/, "")
      sentence.gsub!(/&ldquo;/, "")
      next if sentence =~ /[,.?!:] /
      @sentence = Sentence.create(lesson_id: @lesson.id, name: sentence)
      ## 将句子中的非中文字符用空格隔开
      chinese_pattern = /[\u4e00-\u9fa5]/
      none_chinese_part = sentence.split(chinese_pattern).delete_if{|x| x == ""}
      none_chinese_part.each do |p|
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
    @end_at = Time.now
    @duaration = @end_at - @begin_at
    redirect_to words_report_url(@words_report), notice: "让您久等了。本次分析开始于#{@begin_at}，结束于#{@end_at}。用时#{@duaration.to_i/60}分#{@duaration.to_i.modulo(60)}秒。"
    rescue
      @lesson.word_parsers.destroy_all
      @lesson.sentences.destroy_all
      @words_report.destroy
      respond_to do |format|
        format.html { redirect_to :back, notice: "对课文解析出错。建议您将情况通过“建议”向管理员反映。"}
        format.json { head :no_content }
      end
    end
=end
  end

  # Get /lessons/1/as_tutor_link  
  # 用于单独显示课程内容，隐去其他功能。
  def as_tutor_link
    @origin_lesson = Lesson.find_by(id: session[:lesson_id])
    unless @origin_lesson
      redirect_to :back, notice: "无法确定辅导关联的课文。"
      return
    end
    @lesson = Lesson.find_by(id: params[:lesson_id])
    unless @lesson
      redirect_to :back, notice: "无法找到辅导关联的课文。"
      return
    end
  end

  # GET /lesson/as_tutor
  # 用户可在本页面选择目标课程。
  def as_tutor
    @lesson = Lesson.find(session[:lesson_id])
  end

  # POST /lesson/to_tutor
  def to_tutor
    @lesson = Lesson.find_by(id: session[:lesson_id])
    @target = Lesson.find_by(id: params[:lesson_id])
    unless @lesson
      redirect_to 'root_path', notice: "未指定课程，无法创建辅导。"
      return
    end
    unless  @target
      redirect_to 'root_path', notice: "未指定目标，无法创建辅导。"
      return
    end
    if @lesson.id == @target.id
      redirect_to :back, notice: "请重新指定一片课文。"
      return
    end
    if @lesson.author
      lesson_title = @lesson.title + "（" + @lesson.author + "）"
    else
      lesson_title = @lesson.title
    end
    if @target.author
      target_title = @target.title + "（" + @target.author + "）"
    else
      target_title = @target.title
    end
    @tutor = Tutor.create(title: lesson_title, lesson_id: @target.id, difficulty: 800, user_id: current_user.id, proviso: "全文" + @lesson.content_length.to_s + "字。<a href=\"/lessons/#{@lesson.id}/as_tutor_link\">点击阅读</a>", page_length: @lesson.content_length)
    Tutor.create(title: target_title, lesson_id: @lesson.id, difficulty: 800, user_id: current_user.id, proviso: "全文" + @target.content_length.to_s + "字。<a href=\"/lessons/#{@target.id}/as_tutor_link\">点击阅读</a>", page_length: @target.content_length)
    session[:lesson_id] = @target.id
    respond_to do |format|
      format.html { redirect_to @tutor, notice: "辅导《#{@tutor.title}》已经成功生成。" }
      format.json { head :no_content }
    end
  end

  # GET /choose_a_textbook
  def choose_a_textbook
    session[:textbook_id] = params[:textbook_id]
    respond_to do |format|
      format.html { redirect_to :back, notice: "成功选择课本。" }
      format.json { head :no_content }
    end
  end

  # GET /lesson_quickly_find_similar_lessons?lesson_id=num
  def lesson_quickly_find_similar_lessons
    @target_lesson = Lesson.find_by(id: params[:lesson_id])
    unless @target_lesson
      redirect_to :back, notice: '请先指定一个课程'
      return
    end
    all_word_ids = WordParser.where(lesson_id: @target_lesson.id).pluck(:word_id).uniq
    word_ids = Word.where(id: all_word_ids, length: 1).pluck(:id)
    all_similar_lessons_id = WordParser.where(word_id: word_ids).pluck(:lesson_id)
    all_similar_lessons_id_in_length = Lesson.where(id: all_similar_lessons_id).where("content_length < ?", @target_lesson.content_length*2).pluck(:id)
    counter = Hash.new(0)
    all_similar_lessons_id.each {|lesson_id| counter[lesson_id]+=1 if all_similar_lessons_id_in_length.include?(lesson_id)}
    @lessons_id_with_count = counter.sort{|a,b| a[1]<=>b[1]}.last(101).reverse
  end

  # get /lesson_similar_title_lessons?lesson_id=num
  def lesson_similar_title_lessons
    @target_lesson = Lesson.find_by(id: params[:lesson_id])
    unless @target_lesson
      redirect_to :back, notice: '请先指定一个课程'
      return
    end
    lesson_titles = @target_lesson.title.split(/\s/).map{|word|(word =~ /[\u4e00-\u9fa5]/)? word.chars : word}.flatten.uniq
    similar_title_lessons_id = []
    lesson_titles.each do |title|
      similar_title_lessons_id << Lesson.where("title LIKE ?", "%" + title +"%" ).pluck(:id)
    end
    similar_title_lessons_id.flatten!
    @lessons_id = similar_title_lessons_id.sort_by{|i|similar_title_lessons_id.find_all{|j|j==i}.count}.uniq.reverse.first(101)
    unless @lessons_id.any?
      redirect_to :back, notice: '找不到标题类似的课文'
    end
  end 

  # get /lesson_same_author_lessons?lesson_id=num
  def lesson_same_author_lessons
    @target_lesson = Lesson.find_by(id: params[:lesson_id])
    unless @target_lesson
      redirect_to :back, notice: '请先指定一个课程'
      return
    end
    lesson_authors = @target_lesson.author.gsub(/[(（\[].+[)）\]]/, "").split(/\s|,|，|、/).flatten.uniq
    similar_author_lessons_id = []
    lesson_authors.each do |author|
      similar_author_lessons_id << Lesson.where("author LIKE ?", "%" + author +"%" ).pluck(:id)
    end 
    similar_author_lessons_id.flatten!
    @lessons_id = similar_author_lessons_id.sort_by{|i|similar_author_lessons_id.find_all{|j|j==i}.count}.uniq.reverse
    if @lessons_id.size == 1
      redirect_to :back, notice: '找不到同一作者写的其他课文'
      return
    end
  end 

  # get /lesson_similar_time_lessons?lesson_id=num
  def lesson_similar_time_lessons
    @target_lesson = Lesson.find_by(id: params[:lesson_id])
    unless @target_lesson
      redirect_to :back, notice: '请先指定一个课程'
      return
    end
    similar_time_lessons = []
    @lessons_id = Lesson.where(time: @target_lesson.time).pluck(:id)
    if @lessons_id.size < 101
      1.upto(100){|i|
        @lessons_id << Lesson.where(time: @target_lesson.time-i).pluck(:id)
        @lessons_id << Lesson.where(time: @target_lesson.time+i).pluck(:id)
        @lessons_id.flatten!
        break if @lessons_id.size >= 101
      }
    end
  end 

  # get /lesson_content_as_practice_material
  # 把课程正文当作 practice 的材料
  def lesson_content_as_practice_material
    @lesson = Lesson.find(params[:lesson_id])
    if @lesson.content.blank?
      redirect_to :back, notice: '课文正文不能为空。'
      return
    end
    practice_material = '<p>请点击阅读《<a href="/lessons/' + @lesson.id.to_s + '/as_tutor_link">'+ @lesson.title + '</a>》，然后回答下面的问题。</p>'
    @practice = Practice.create(user_id: current_user.id, title: '简答题', question: "问题", material: practice_material, answer: '答案')
    LessonPractice.create(lesson_id: @lesson.id, practice_id: @practice.id)
    redirect_to practice_path(@practice), notice: '已经根据课文正文生成一个练习，请修改问题和答案。'
  end

  # post compare_with_wordmap
  def compare_with_wordmap
    @wordmap = Wordmap.find(params[:wordmap_id]) # 标准
    @wordmap_size = @wordmap.wordorders.last.serial # 标准长度
    @wordmap_average = @wordmap_size / 2  # 标准平均分数
    @wordmap_quarter = @wordmap_average / 2  # 标准四分之一
    @wordmap_3quarter = @wordmap_average + @wordmap_quarter  # 标准四分之三
    @lesson = Lesson.find(params[:lesson_id]) # 课程
    words_from_lesson = WordParser.includes(:word).where(lesson_id: @lesson.id, words: {length: 2..10, is_meanful: true}).pluck(:word_id).uniq 
    @words_from_lesson_size = words_from_lesson.size # 课程词汇总数
    words_from_wordmap = @wordmap.wordorders.pluck(:word_id)
    @same_words = words_from_lesson & words_from_wordmap
    @totalmark = Wordorder.where(wordmap: @wordmap.id, word_id: @same_words).pluck(:serial).inject(:+)
    @average = @totalmark/@same_words.size
    @benchmark = @average.to_f/(@wordmap_size/2)
    @same_percent_in_lesson = @same_words.size.to_f * 100  / words_from_lesson.size
    @diff_words_from_lesson =  words_from_lesson - words_from_wordmap
  end

  # post compare_single_with_wordmap
  def compare_single_with_wordmap
    @wordmap = Wordmap.find(params[:wordmap_id]) # 标准
    @wordmap_size = @wordmap.wordorders.last.serial # 标准长度
    @wordmap_average = @wordmap_size / 2  # 标准平均分数
    @wordmap_quarter = @wordmap_average / 2  # 标准四分之一
    @wordmap_3quarter = @wordmap_average + @wordmap_quarter  # 标准四分之三
    @lesson = Lesson.find(params[:lesson_id]) # 课程
    # words_from_lesson = WordParser.includes(:word).where(lesson_id: @lesson.id, words: {length: 1}).pluck(:word_id).uniq 
    word_from_lesson = @lesson.content.chars.uniq
    words_from_lesson = Word.where(name: word_from_lesson)
    words_from_lesson = WordParser.includes(:word).where(lesson_id: @lesson.id, words: {length: 1}).pluck(:word_id).uniq 
    @words_from_lesson_size = words_from_lesson.size # 课程字符总数
    words_from_wordmap = @wordmap.wordorders.pluck(:word_id) # 标准里的单词
    @same_words = words_from_lesson & words_from_wordmap  # 课程和标准里共同有的单词
    @totalmark = Wordorder.where(wordmap: @wordmap.id, word_id: @same_words).pluck(:serial).inject(:+) # 共有单词总得分
    @average = @totalmark/@same_words.size  # 共有单词平均得分
    @benchmark = @average.to_f/(@wordmap_size/2)  # 共有单词平均得分和标准平均分比率
    @same_percent_in_lesson = @same_words.size.to_f * 100  / words_from_lesson.size # 共有单词占课程单词的比率
    @diff_words_from_lesson =  words_from_lesson - words_from_wordmap  # 课程超出标准的单词
    render :compare_with_wordmap
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lesson
      @lesson = Lesson.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lesson_params
      params.require(:lesson).permit(:title, :content, :user_id, :picture, :time, :author, :source)
    end

    def be_a_master
      unless Master.find_by(user_id: current_user.id)
        redirect_to :back, notice: "对不起，您暂时还没有老师的身份，无法进行操作。"
      end
    end

  # after_save的回调方法
  def update_length
    @lesson.content_length = @lesson.content.gsub(/(<(\w|\/)+[^>]*>|\s)/, "").length
    @lesson.save
  end

end
