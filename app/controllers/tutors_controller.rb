class TutorsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_tutor, only: [:show, :edit, :update, :destroy]

  # GET /tutors
  # GET /tutors.json
  def index
    if current_user.has_role? :admin
      @tutors = Tutor.all
    else
      @lesson = Lesson.find_by(id: session[:lesson_id])
      @tutors = Tutor.where(lesson_id: session[:lesson_id]).order('difficulty')
    end
  end

  # GET /tutors/1
  # GET /tutors/1.json
  def show
    history = History.create { |h| 
      h.user_id = current_user.id
      h.modelname = "tutor"
      h.entryid = @tutor.id
    }
    @other_tutors = Tutor.where(lesson_id: session[:lesson_id], title: @tutor.title).where.not(id: @tutor.id)
    session[:tutor_id] = @tutor.id
    @lesson = Lesson.find_by(id: session[:lesson_id])
    @practice = Practice.find_by(tutor_id: @tutor.id)
    @exercises = Exercise.where(tutor_id: @tutor.id)
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
    @tutor = Tutor.new
  end

  # GET /tutors/1/edit
  def edit
  end

  # POST /tutors
  # POST /tutors.json
  def create
    @tutor = Tutor.new(tutor_params)
    @tutor.user_id = current_user.id
    @tutor.lesson_id = session[:lesson_id]
    @tutor.page_length = @tutor.page.gsub(/(<(\w|\/)+[^>]*>|\s)/, "").length

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
    respond_to do |format|
      if @tutor.update(tutor_params)
        @tutor.page_length = @tutor.page.gsub(/(<(\w|\/)+[^>]*>|\s)/, "").length
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tutor
      @tutor = Tutor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tutor_params
      params.require(:tutor).permit(:lesson_id, :title, :difficulty, :page, :user_id, :picture1, :picture2, :proviso)
    end
end
