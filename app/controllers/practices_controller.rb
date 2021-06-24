class PracticesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_practice, only: [:show, :edit, :update, :destroy]
  before_action :be_a_master, except: [:index, :show]
  autocomplete :lesson, :title, full: true, :display_value => :funky_method, extra_data: [:id]

  # GET /practices
  # GET /practices.json
  def index
    if current_user.has_role? :admin 
      @practices = Practice.all
    elsif session[:lesson_id]
      @lesson = Lesson.find(session[:lesson_id])
      case params[:order_type]
      when nil
        @practices = @lesson.practices.order(:score, :id)
        @order_type = nil
      when "created_at"
        @practices = @lesson.practices.order(:id)
        @order_type = "created_at"
      when "title"
        @practices = @lesson.practices.order(:title, :id)
        @order_type = "title"
      when "labelname"
        @practices = @lesson.practices.order(:labelname, :id)
        @order_type = "labelname"
      when "question"
        @practices = @lesson.practices.order(:question, :id)
        @order_type = "question"
      end
    else
      redirect_to list_all_practices_path, notice: "需要指定课文。"
    end
  end

  # GET /practices/1
  # GET /practices/1.json
  def show
    history = History.create { |h| 
      h.user_id = current_user.id
      h.modelname = "practice"
      h.entryid = @practice.id
    }
    session[:practice_id] = @practice.id
    # @lesson = Lesson.find_by(id: @practice.lesson_id)
    if session[:lesson_id]
    @lesson = Lesson.find_by(id: session[:lesson_id])
    #@tutor = Tutor.find_by(id: @practice.tutor_id)
    @practices = @lesson.practices.order(:score)
    @practices.each_with_index do | practice, index |
      if practice == @practice
        if index - 1 < 0
	        @previous_practice = nil  
	      else
	        @previous_practice = @practices[index - 1] 
	      end
	      if index + 1 == @practices.length
	        @next_practice = nil
	      else
	        @next_practice = @practices[index + 1]
	      end
      end
    end
    end
    word_ids = PracticeParser.where(practice_id: @practice.id).pluck(:word_id)
    @word_count = word_ids.count
    all_similar_practices_id = PracticeParser.where(word_id: word_ids).pluck(:practice_id)
    counter = Hash.new(0)
    all_similar_practices_id.each {|practice_id| counter[practice_id]+=1 if all_similar_practices_id.include?(practice_id)}
    @practices_id_with_count = counter.sort{|a,b| a[1]<=>b[1]}.last(21).reverse
  end

  # GET /practices/new
  def new
    @practice = Practice.new
  end

  # GET /practices/1/edit
  def edit
  end

  # POST /practices
  # POST /practices.json
  def create
    @practice = Practice.new(practice_params)
    unless current_user.has_role? :admin
      @practice.user_id = current_user.id
      unless @practice.score
        @practice.score = (@practice.answer.to_s.gsub(/(<(\w|\/)+[^>]*>|\s)/, "").length.to_f / 10).ceil
      end
    end
    respond_to do |format|
      if @practice.save
        # 对练习进行分析（标题，问题，答案，不包括材料）
        AnalyzePracticeJob.perform_later @practice.id
        if session[:lesson_id]
          LessonPractice.create(lesson_id: session[:lesson_id], practice_id: @practice.id)
        end
        if session[:tutor_id]
          last_exercise = Exercise.where(tutor_id: session[:tutor_id]).order(:serial).last
          if last_exercise
            Exercise.create(tutor_id: session[:tutor_id], practice_id: @practice.id, user_id: current_user.id, serial: last_exercise.serial + 1)
          else
            Exercise.create(tutor_id: session[:tutor_id], practice_id: @practice.id, user_id: current_user.id, serial: 1)
          end
        end
        format.html { redirect_to @practice, notice: "练习#{@practice.id}已经成功添加" }
        format.json { render :show, status: :created, location: @practice }
      else
        format.html { render :new }
        format.json { render json: @practice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /practices/1
  # PATCH/PUT /practices/1.json
  def update
    # unless current_user.has_role? :admin
    # @practice.score = (@practice.answer.to_s.gsub(/(<(\w|\/)+[^>]*>|\s)/, "").length.to_f / 10).ceil
    # end
    respond_to do |format|
      if @practice.update(practice_params)
        # 对练习进行分析（标题，问题，答案，不包括材料）
        AnalyzePracticeJob.perform_later @practice.id
        format.html { redirect_to @practice, notice: "练习#{@practice.id}已经更新成功" }
        format.json { render :show, status: :ok, location: @practice }
      else
        format.html { render :edit }
        format.json { render json: @practice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /practices/1
  # DELETE /practices/1.json
  def destroy
    @practice.destroy
    respond_to do |format|
      format.html { redirect_to practices_url, notice: "练习#{@practice.id}已经被成功删除" }
      format.json { head :no_content }
    end
  end

  def delete_picture_q
    @practice = Practice.find(session[:practice_id])
    @practice.picture_q = nil
    @practice.save
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, notice: "问题图片已经被删除" }
      format.json { head :no_content }
    end
  end

  def delete_picture_a
    @practice = Practice.find(session[:practice_id])
    @practice.picture_a = nil
    @practice.save
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, notice: "答案图片已经被删除" }
      format.json { head :no_content }
    end
  end

  def create_practices_in_batch
    begin
      @lesson = Lesson.find(session[:lesson_id])
      @tutor = Tutor.find(session[:tutor_id]) if session[:tutor_id]
      @practices = []
      name =  current_user.name + Time.now.to_s
      directory = "public/data_import"
      path = File.join(directory, name)
      File.open(path, "wb") { |f| f.write(params[:csv_file].read) }
      data = SmarterCSV.process(path) do |allline|
        allline.each do |line|
          p = Practice.new 
          p.user_id = current_user.id
          # p.lesson_id = session[:lesson_id]
          p.labelname = line[:标签]
          p.title = line[:标题]
          p.material = line[:材料]
          p.question = line[:问题]
          p.answer = line[:答案]
          p.score = line[:分值] || (p.answer.to_s.length.to_f / 10).ceil
          p.save!
          AnalyzePracticeJob.perform_later p.id
          LessonPractice.create(lesson_id: @lesson.id, practice_id: p.id)
          @practices << p
        end
      end
      unless session[:tutor_id]
        redirect_back fallback_location: root_path, notice: '成功导入练习！'
        return
      end
    rescue 
      File.delete(path)
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, notice: '导入练习失败，请修改CSV文件后重新尝试！' }
        format.json { head :no_content }
      end
    end
  end

  def add_to_paper
    @practice = Practice.find(params[:practice_id])
    if Paperitem.find_by(paper_id: session[:paper_id], practice_id: @practice.id)
      redirect_back fallback_location: root_path, notice: "您之前已经将这道题添加到试卷中。"
      return
    else
      @paperitem = Paperitem.create{ |pi|
        pi.user_id = current_user.id
        pi.paper_id = session[:paper_id]
        pi.practice_id = @practice.id
        pi.score = @practice.score
      }
      redirect_back fallback_location: root_path, notice: "成功将这道题添加到试卷中！"
    end
  end

  # get /list_all_practices
  def list_all_practices
    @practices = Practice.all.order(:id).page(params[:page]).per("100")
  end

  # get /search_practices
  def search_practices
    @search_key = params[:key_word]
    word_content =  []
    word_content << @search_key.scan(/\w+/)
    word_content << @search_key.scan(/[\u4e00-\u9fa5]/)
    word_content.flatten!
    word_content.uniq!
    words_id = Word.where(name: word_content).pluck(:id)
    practices_id = []
    practices_id = PracticeParser.where(word_id: words_id).pluck(:practice_id)
    counter = Hash.new(0)
    practices_id.each {|practice_id| counter[practice_id]+=1 if practices_id.include?(practice_id)}
    search_practices_id = counter.keep_if{|k, v| v == words_id.size}.keys
    @practices = Practice.where(id: search_practices_id).order(:id).page(params[:page]).per("100")
    render :list_all_practices, notice: "成功找到这些匹配的习题。"
  end

  def practice_add_to_lesson
   @lesson_practice = LessonPractice.find_by(lesson_id: params[:lesson_id], practice_id: params[:practice_id])
   if @lesson_practice
    redirect_back fallback_location: root_path, notice: '习题已经在课程中。'
   else
    LessonPractice.create(lesson_id: params[:lesson_id], practice_id: params[:practice_id])
    redirect_back fallback_location: root_path, notice: '已经将习题添加到课程中。'
   end
  end

  def practice_delete_from_lesson
    @lesson_practice = LessonPractice.find_by(lesson_id: params[:lesson_id], practice_id: params[:practice_id])
    @lesson_practice.destroy
    redirect_to practices_path, notice: '习题已经被清理出课程。'
  end

  def practice_add_to_tutor
   @lesson_practice = LessonPractice.find_by(lesson_id: params[:lesson_id], practice_id: params[:practice_id])
    unless @lesson_practice
      LessonPractice.create(lesson_id: params[:lesson_id], practice_id: params[:practice_id])
    end
   @exercise = Exercise.find_by(tutor_id: params[:tutor_id], practice_id: params[:practice_id])
   if @exercise
    redirect_back fallback_location: root_path, notice: '习题已经在辅导中。'
   else
    last_exercise = Exercise.where(tutor_id: params[:tutor_id]).order(:serial).last
    if last_exercise
      Exercise.create(tutor_id: params[:tutor_id], practice_id: params[:practice_id], user_id: current_user.id, serial: last_exercise.serial + 1)
    else
      Exercise.create(tutor_id: params[:tutor_id], practice_id: params[:practice_id], user_id: current_user.id, serial: 1)
    end
    redirect_back fallback_location: root_path, notice: '已经将习题添加到辅导中。'
   end
  end

  def analysize
    AnalyzePracticeJob.perform_later params[:practice_id]
    redirect_back fallback_location: root_path, notice: '已经将习题添加到分析队列中。'
  end

  # post /practices/1/copy_to_another_lesson
  def copy_to_another_lesson
    unless session[:practice_id]
      redirect_back fallback_location: root_path, notice: "无法找到相应的练习。"
      return
    end
    another_lesson = Lesson.find_by(id: params[:lesson_id])
    unless another_lesson
      redirect_back fallback_location: root_path, notice: "无法找到指定的课程。"
      return
    end
   @lesson_practice = LessonPractice.find_by(lesson_id: params[:lesson_id], practice_id: session[:practice_id])
   if @lesson_practice
      redirect_back fallback_location: root_path, notice: "指定课程已有本习题，无需重新添加。"
    else
      LessonPractice.create(lesson_id: params[:lesson_id], practice_id: session[:practice_id])
      redirect_back fallback_location: root_path, notice: "已经将本题复制到课文《#{another_lesson.title}》（#{another_lesson.id}）中。"
    end
  end

  def practice_change_to_lesson
    unless session[:lesson_id]
      redirect_back fallback_location: root_path, notice: "无法找到相应的课程。"
      return
    end
    unless session[:practice_id]
      redirect_back fallback_location: root_path, notice: "无法找到相应的练习。"
      return
    end
    another_lesson = Lesson.find_by(id: params[:lesson_id])
    unless another_lesson
      redirect_back fallback_location: root_path, notice: "无法找到指定的课程。"
      return
    end
    @lesson_practice = LessonPractice.find_by(lesson_id: params[:lesson_id], practice_id: session[:practice_id])
    if @lesson_practice
      LessonPractice.find_by(lesson_id: session[:lesson_id], practice_id: session[:practice_id]).destroy
    else
      LessonPractice.find_by(lesson_id: session[:lesson_id], practice_id: session[:practice_id]).update(lesson_id: params[:lesson_id])
    end
    redirect_back fallback_location: root_path, notice: '已经将习题转移到指定的课程中。'
  end

  def all_in_table
    if session[:lesson_id]
      @lesson = Lesson.find(session[:lesson_id])
      case params[:order_type]
      when nil
        @practices = @lesson.practices.order(:score, :id)
        @order_type = nil
      when "created_at"
        @practices = @lesson.practices.order(:id)
        @order_type = "created_at"
      when "title"
        @practices = @lesson.practices.order(:title, :id)
        @order_type = "title"
      when "labelname"
        @practices = @lesson.practices.order(:labelname, :id)
        @order_type = "labelname"
      when "question"
        @practices = @lesson.practices.order(:question, :id)
        @order_type = "question"
      end
    else
      redirect_to list_all_practices_path, notice: "需要指定课文。"
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_practice
      @practice = Practice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def practice_params
      params.require(:practice).permit(:title, :material, :question, :answer, :user_id, :tutor_id, :lesson_id, :activate, :score, :picture_q, :picture_a, :labelname)
    end

    def be_a_master
      unless Master.find_by(user_id: current_user.id)
        redirect_back fallback_location: root_path, notice: "对不起，您暂时还没有老师的身份，无法进行操作。"
      end
    end

end
