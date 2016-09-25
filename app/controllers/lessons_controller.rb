class LessonsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]
  before_action :be_a_master, except: [:index, :show]
  autocomplete :lesson, :title, full: true, :display_value => :funky_method, extra_data: [:id]

  # GET /lessons
  # GET /lessons.json
  def index
      @lessons = Lesson.all.order("time").page(params[:page]).per("10")
  end

  # GET /lessons/1
  # GET /lessons/1.json
  def show
    # 记录足迹
    history = History.create(user_id: current_user.id, modelname: "lesson", entryid: @lesson.id)
    if session[:textbook_id]
      @textbook = Textbook.find_by(id: session[:textbook_id])
      @catalog = Catalog.find_by(textbook_id: @textbook.id, lesson_id: @lesson.id)
    else
      @catalogs = Catalog.where(lesson_id: @lesson.id)
      @textbooks = Textbook.where(id: @catalogs.map{|c| c.textbook_id})
    end
    session[:lesson_id] = @lesson.id
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
    # 生成“前一课”和“后一课”按钮
    all_catalogs = Catalog.where(textbook_id: session[:textbook_id]).order(:serial)
    all_catalogs.each_with_index do | catalog, index |
      if @lesson.id == catalog.lesson_id
        if index - 1 < 0
	        @previous_lesson = nil  
	      else
	        previous_catalog = all_catalogs[index - 1]
	        @previous_lesson = Lesson.find(previous_catalog.lesson_id)
	      end
	      if index + 1 == all_catalogs.length
	        @next_lesson = nil
	      else
	        next_catalog = all_catalogs[index + 1]
	        @next_lesson = Lesson.find(next_catalog.lesson_id)
	      end
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
    @lesson.content_length = @lesson.content.gsub(/(<(\w|\/)+[^>]*>|\s)/, "").length

    respond_to do |format|
      if @lesson.save
        AnalyzeLessonJob.perform_later @lesson.id
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
        @lesson.content_length = @lesson.content.gsub(/(<(\w|\/)+[^>]*>|\s)/, "").length
        @lesson.save
        AnalyzeLessonJob.perform_later @lesson.id
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
    @tutor = Tutor.create(title: @lesson.title + "（" + @lesson.author + "）", lesson_id: @target.id, difficulty: 800, user_id: current_user.id, proviso: "<a href=\"/lessons/#{@lesson.id}/as_tutor_link\">点击阅读</a>", page_length: 4)
    Tutor.create(title: @target.title + "（" + @target.author + "）", lesson_id: @lesson.id, difficulty: 800, user_id: current_user.id, proviso: "<a href=\"/lessons/#{@target.id}/as_tutor_link\">点击阅读</a>", page_length: 4)
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lesson
      @lesson = Lesson.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lesson_params
      params.require(:lesson).permit(:title, :content, :user_id, :picture, :time, :author)
    end

    def be_a_master
      unless Master.find_by(user_id: current_user.id)
        redirect_to :back, notice: "对不起，您暂时还没有老师的身份，无法进行操作。"
      end
    end

end
