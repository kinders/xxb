class LessonsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]
  before_action :be_a_master, except: [:index, :show]

  # GET /lessons
  # GET /lessons.json
  def index
      @lessons = Lesson.all.page params[:page]
  end

  # GET /lessons/1
  # GET /lessons/1.json
  def show
    # 记录足迹
    history = History.create { |h| 
      h.user_id = current_user.id
      h.modelname = "lesson"
      h.entryid = @lesson.id
    }
    session[:lesson_id] = @lesson.id
    session[:tutor_id] = nil
    session[:teaching_id] = nil
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lesson
      @lesson = Lesson.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lesson_params
      params.require(:lesson).permit(:title, :content, :user_id, :picture)
    end

    def be_a_master
      unless Master.find_by(user_id: current_user.id)
        redirect_to :back, notice: "对不起，您暂时还没有老师的身份，无法进行操作。"
      end
    end

end
