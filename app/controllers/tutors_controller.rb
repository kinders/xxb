class TutorsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_tutor, only: [:show, :edit, :update, :destroy]
  before_action :be_a_master, except: [:index, :show]
  autocomplete :lesson, :title, full: true, :display_value => :funky_method, extra_data: [:id]

  # GET /tutors
  # GET /tutors.json
  def index
    if current_user.has_role? :admin
      @tutors = Tutor.all
    else
      session[:tutor_id] = nil
      @lesson = Lesson.find_by(id: session[:lesson_id])
      @tutors = Tutor.where(lesson_id: session[:lesson_id]).order(:difficulty, :created_at)
      unless @lesson
        redirect_to me_summary_url, notice: "无法找到相应的课程。"
      end
    end
  end

  # GET /tutors/1
  # GET /tutors/1.json
  def show
    unless session[:lesson_id]
      redirect_to me_summary_url, notice: "无法找到相应的课程。"
      return
    end
    history = History.create { |h| 
      h.user_id = current_user.id
      h.modelname = "tutor"
      h.entryid = @tutor.id
    }
    @other_tutors = Tutor.where(lesson_id: session[:lesson_id], title: @tutor.title).where.not(id: @tutor.id)
    session[:tutor_id] = @tutor.id
    @lesson = Lesson.find_by(id: session[:lesson_id])
    #@practice = Practice.find_by(tutor_id: @tutor.id)
    @exercises = Exercise.where(tutor_id: @tutor.id).order(:serial)
    # 设置教学环境
    if session[:teaching_id]
      teaching_id = session[:teaching_id]
      @plans = Plan.where(teaching_id: teaching_id).order("serial")
      @tutors_in_plans = []
      @plans.each {|plan| @tutors_in_plans << plan.tutor_id}
      @tutors_in_plans.each_with_index do | tutor, index |
        if tutor == @tutor.id
          if index - 1 < 0
	          @previous_tutor = nil  
	        else
	          @previous_tutor = @tutors_in_plans[index - 1] 
	        end
	        if index + 1 == @tutors_in_plans.length
	          @next_tutor = nil
	        else
	          @next_tutor = @tutors_in_plans[index + 1]
	        end
        end
      end
    else
      @tutors = Tutor.where(lesson_id: session[:lesson_id]).order('difficulty')
      @tutors.each_with_index do | tutor, index |
        if tutor.id == @tutor.id
          if index - 1 < 0
	          @previous_tutor = nil  
	        else
	          @previous_tutor = @tutors[index - 1] 
	        end
	        if index + 1 == @tutors.length
	          @next_tutor = nil
	        else
	          @next_tutor = @tutors[index + 1]
	        end
	      end
      end
    end
  end

  # GET /tutors/new
  def new
    unless session[:lesson_id]
      redirect_to me_summary_url, notice: "无法找到相应的课程。"
      return
    end
    @tutor = Tutor.new
  end

  # GET /tutors/1/edit
  def edit
    unless session[:lesson_id]
      redirect_to me_summary_url, notice: "无法找到相应的课程。"
      return
    end
  end

  # POST /tutors
  # POST /tutors.json
  def create
    unless session[:lesson_id]
      redirect_to me_summary_url, notice: "无法找到相应的课程。"
      return
    end
    @tutor = Tutor.new(tutor_params)
    @tutor.user_id = current_user.id
    @tutor.lesson_id = session[:lesson_id]
    @tutor.page_length = @tutor.page.gsub(/(<(\w|\/)+[^>]*>|\s)/, "").length + @tutor.proviso.gsub(/(<(\w|\/)+[^>]*>|\s)/, "").length

    respond_to do |format|
      if @tutor.save
        format.html { redirect_to @tutor, notice: "Tutor“#{@tutor.title}”已经添加成功" }
        format.json { render :show, status: :created, location: @tutor }
      else
        format.html { render :new }
        format.json { render json: @tutor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tutors/1
  # PATCH/PUT /tutors/1.json
  def update
    unless session[:lesson_id]
      redirect_to me_summary_url, notice: "无法找到相应的课程。"
      return
    end
    respond_to do |format|
      if @tutor.update(tutor_params)
        @tutor.page_length = @tutor.page.gsub(/(<(\w|\/)+[^>]*>|\s)/, "").length + @tutor.proviso.gsub(/(<(\w|\/)+[^>]*>|\s)/, "").length
        @tutor.save
        format.html { redirect_to @tutor, notice: "Tutor“#{@tutor.title}”已经更新成功" }
        format.json { render :show, status: :ok, location: @tutor }
      else
        format.html { render :edit }
        format.json { render json: @tutor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tutors/1
  # DELETE /tutors/1.json
  def destroy
    @tutor.destroy
    respond_to do |format|
      format.html { redirect_to tutors_url, notice: "Tutor“#{@tutor.title}”已经被删除" }
      format.json { head :no_content }
    end
  end
  
  def delete_picture1
    @tutor = Tutor.find(session[:tutor_id])
    @tutor.picture1 = nil
    @tutor.save
    respond_to do |format|
      format.html { redirect_to :back, notice: "图片一已经被删除" }
      format.json { head :no_content }
    end
  end

  def delete_picture2
    @tutor = Tutor.find(session[:tutor_id])
    @tutor.picture2 = nil
    @tutor.save
    respond_to do |format|
      format.html { redirect_to :back, notice: "图片二已经被删除" }
      format.json { head :no_content }
    end
  end

  # GET /tutors/new_link_to_lesson
  def new_link_to_lesson
    unless session[:lesson_id]
      redirect_to me_summary_url, notice: "无法找到相应的课程。"
      return
    end
    @lesson = Lesson.find_by(id: session[:lesson_id])
  end

  # POST /tutors/create_link_to_lesson
  def create_link_to_lesson
    @lesson = Lesson.find_by(id: session[:lesson_id])
    unless @lesson
      redirect_to 'root_path', notice: "未指定课程，无法创建辅导。"
      return
    end
    @target = Lesson.find_by(id: params[:lesson_id])
    @tutor = Tutor.create(title: @target.title, lesson_id: @lesson.id, difficulty: 800, user_id: current_user.id, proviso: "全文" + @target.content_length.to_s + "字。<a href=\"/lessons/#{@target.id}/as_tutor_link\">点击阅读</a>", page_length: @target.content_length)
    @another_tutor = Tutor.create(title: @lesson.title, lesson_id: @target.id, difficulty: 800, user_id: current_user.id, proviso: "全文" + @lesson.content_length.to_s + "字。<a href=\"/lessons/#{@lesson.id}/as_tutor_link\">点击阅读</a>", page_length: @lesson.content_length)
    respond_to do |format|
      format.html { redirect_to @tutor, notice: "辅导《#{@tutor.title}》已经成功生成。" }
      format.json { head :no_content }
    end
  end

  # GET /tutor/to_practice
  def to_practice
    unless session[:lesson_id]
      redirect_to me_summary_url, notice: "无法找到相应的课程。"
      return
    end
    @tutor = Tutor.find(session[:tutor_id])
    @lesson = Lesson.find(session[:lesson_id])
    practice = Practice.create { |p|
      p.user_id = current_user.id
      p.lesson_id = session[:lesson_id]
      p.title = "简答题"
      p.material = @tutor.proviso
      p.question = @tutor.title
      p.answer = @tutor.page
      p.score = (p.answer.to_s.length.to_f / 10).ceil
    } 
    last_exercise = Exercise.where(tutor_id: @tutor.id).order(:serial).last
    if last_exercise
      last_exercise_serial = last_exercise.serial
    else
      last_exercise_serial = 0
    end
    Exercise.create { |e| 
      e.user_id = current_user.id
      e.tutor_id = @tutor.id
      e.serial  =  last_exercise_serial + 1 
      e.practice_id = practice.id
    }
    respond_to do |format|
      format.html { redirect_to @tutor, notice: "已经将辅导《#{@tutor.title}》转为习题。" }
      format.json { head :no_content }
    end
  end

  # GET /tutor/create_pinyin_help_tutor
  def create_pinyin_help_tutor
    unless session[:lesson_id]
      redirect_to me_summary_url, notice: "无法找到相应的课程。"
      return
    end
    @lesson = Lesson.find(session[:lesson_id])
    content = "<h2>" + @lesson.title + "</h2><hr>" + @lesson.content
    contents = content.chars
    contents.map! do |char|
      word = Word.find_by(name: char.to_s)
      if word
        if word.name =~ /[\u4e00-\u9fa5]/
          pinyins = word.phonetics.map{|p| p.content}.join(" ")
          char = "<ruby>" + char.to_s + "<rp>【</rp><rt> " + pinyins + " </rt><rp>】</rp></ruby>"
        else
        char
        end
      else
        char
      end
    end
    new_content = contents.join
    @tutor = Tutor.create(title: "注音助读", difficulty: 1, page: new_content, user_id: current_user.id, lesson_id: @lesson.id, page_length: new_content.size)
    redirect_to @tutor, notice: "已经生成助读辅导，请您对多音字进行选定修改。"
  end

  # get /tutor/1/show_with_lesson
  def show_with_lesson
    unless session[:lesson_id]
      redirect_to me_summary_url, notice: "无法找到相应的课程。"
      return
    end
    if session[:tutor_id]
      @tutor = Tutor.find(session[:tutor_id])
      @lesson = @tutor.lesson
      @exercises = Exercise.where(tutor_id: @tutor.id).order(:serial)
    else
      redirect_to tutors_url, notice: "未指定辅导。"
    end
  end

  # post /tutor/1/choose_a_lesson
  def choose_a_lesson
    unless session[:lesson_id]
      redirect_to me_summary_url, notice: "无法找到相应的课程。"
      return
    end
    if session[:tutor_id]
      @tutor = Tutor.find(session[:tutor_id])
      @tutor.update(lesson_id: params[:lesson_id])
      session[:lesson_id] = params[:lesson_id]
      redirect_to tutor_path(@tutor.id), notice: "已经将辅导更新到课文中。"
    else
      redirect_to tutors_url, notice: "未指定辅导。"
    end
  end

  # post /tutor/1/copy_to_another_lesson
  def copy_to_another_lesson
    unless session[:lesson_id]
      redirect_to me_summary_url, notice: "无法找到相应的课程。"
      return
    end
    another_lesson = Lesson.find_by(id: params[:lesson_id])
    unless another_lesson
      redirect_to :back, notice: "无法找到指定的课程。"
      return
    end
    if session[:tutor_id]
      @tutor = Tutor.find(session[:tutor_id])
      new_tutor = Tutor.create(title: @tutor.title, difficulty: @tutor.difficulty, page: @tutor.page, user_id: current_user.id, lesson_id: params[:lesson_id], proviso: @tutor.proviso, page_length: @tutor.page_length)
      @tutor.exercises.each do |e|
        Exercise.create(user_id: current_user.id, tutor_id: new_tutor.id, serial: e.serial, practice_id: e.practice_id)
      end
      redirect_to tutor_path(@tutor.id), notice: "已经将辅导更新到课文《#{another_lesson.title}》（#{another_lesson.id}）中。"
    else
      redirect_to tutors_url, notice: "未指定辅导。"
    end
  end

  # post /tutor/1/append_cardbox_link
  def append_cardbox_link
    unless session[:lesson_id]
      redirect_to me_summary_url, notice: "无法找到相应的课程。"
      return
    end
    if session[:tutor_id]
      @cardbox = Cardbox.find(params[:cardbox_id])
      @tutor = Tutor.find(session[:tutor_id])
      new_proviso = @tutor.proviso + "<p class=\"pull-right\" style=\"font-size:10px;\">使用<a href=\"/cardboxes/#{params[:cardbox_id]}\">卡片盒（#{@cardbox.name}）</a></p>"
      @tutor.update(proviso: new_proviso)
      redirect_to tutor_path(@tutor.id), notice: "已经将卡片盒添加到辅导页面下方。"
    else
      redirect_to tutors_url, notice: "未指定辅导。"
    end
  end

  def download_exercises
    @tutor = Tutor.find(session[:tutor_id])
    practice_ids = @tutor.exercises.map{|e|e.practice_id}
    @practices = Practice.where(id: practice_ids)
    @filename = "辅导“#{@tutor.title}”里的练习题——#{Time.now.to_formatted_s(:number)}.csv"
    @output_encoding = "UTF-8"
    respond_to do |format|
      format.csv # make sure you have action_name.csv.csvbuilder template in place
    end 
  end

  # GET /tutor/create_multi_pinyin_tutor
  def create_multi_pinyin_tutor
    unless session[:lesson_id]
      redirect_to me_summary_url, notice: "无法找到相应的课程。"
      return
    end
    @lesson = Lesson.find(session[:lesson_id])
    content = @lesson.title + @lesson.content
    contents = content.gsub(/<[^>]+>/, "").chars.uniq
    contents.map! do |char|
      word = Word.find_by(name: char.to_s)
      if word && word.name =~ /[\u4e00-\u9fa5]/
        if word.phonetics.count > 1
          pinyins = word.phonetics.map{|p| p.content}.join(" ")
          char = "<p><strong>" + char.to_s + "</strong>： " + pinyins + "</p>"
        end
      end
    end
    new_content = contents.join
    @tutor = Tutor.create(title: "多音字", difficulty: 1, page: new_content, user_id: current_user.id, lesson_id: @lesson.id, page_length: new_content.size)
    redirect_to @tutor, notice: "已经导出多音字，请您对多音字进行选定修改。"
  end

  # GET /tutor/create_pinyin_page_for_tutor
  def create_pinyin_page_for_tutor
    unless session[:lesson_id]
      redirect_to me_summary_url, notice: "无法找到相应的课程。"
      return
    end
    @lesson = Lesson.find(session[:lesson_id])
    @tutor = Tutor.find(params[:tutor_id])
    unless @tutor.page.blank?
      redirect_to :back, notice: '辅导页面已经存在内容。'
      return
    end
    contents = @tutor.proviso.chars
    contents.map! do |char|
      word = Word.find_by(name: char.to_s)
      if word
        if word.name =~ /[\u4e00-\u9fa5]/
          pinyins = word.phonetics.map{|p| p.content}.join(" ")
          char = "<ruby>" + char.to_s + "<rp>【</rp><rt> " + pinyins + " </rt><rp>】</rp></ruby>"
        else
        char
        end
      else
        char
      end
    end
    new_content = contents.join
    @tutor = @tutor.update(page: new_content, page_length: new_content.size)
    redirect_to :back, notice: "已经生成辅导助读，请您对多音字进行选定修改。"
  end

  def create_explain_page_for_tutor
    unless session[:lesson_id]
      redirect_to me_summary_url, notice: "无法找到相应的课程。"
      return
    end
    @lesson = Lesson.find(session[:lesson_id])
    @tutor = Tutor.find(params[:tutor_id])
    unless @tutor.page.blank?
      redirect_to :back, notice: '辅导页面已经存在内容。'
      return
    end
    delete_pattern = /(<[^>]*>)|(\r)|(\n)/
    contents = @tutor.proviso.gsub(delete_pattern, "").split("，")
    new_content = ""
    contents.each do |w|
      word = Word.find_by(name: w)
      if word
        p = word.phonetics.pluck("content").join(", ")
        m = word.meanings.pluck("content").join("！！！").gsub(delete_pattern, '')
      else
        p = ""
        m = ""
      end
      new_content << "<p><b>" + w + "</b> [" + p + "] " + m + "</p>"
    end
    @tutor = @tutor.update(page: new_content, page_length: new_content.size)
    redirect_to :back, notice: "已经生成词语解释，请您对内容进行选定修改。"
  end

  def just_for_show
    @tutor = Tutor.find(params[:tutor_id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tutor
      @tutor = Tutor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tutor_params
      params.require(:tutor).permit(:lesson_id, :title, :difficulty, :page, :user_id, :picture1, :picture2, :proviso)
    end

    def be_a_master
      unless Master.find_by(user_id: current_user.id)
        redirect_to :back, notice: "对不起，您暂时还没有老师的身份，无法进行操作。"
      end
    end

end
