class PlansController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_plan, only: [:show, :edit, :update, :destroy]
  before_action :be_a_master, except: [:index, :show]

  # GET /plans
  # GET /plans.json
  def index
    if current_user.has_role? :admin
      @plans = Plan.all
    elsif session[:lesson_id] && session[:teaching_id]
      @lesson = Lesson.find(session[:lesson_id])
      teaching_id = session[:teaching_id]
      @teaching = Teaching.find(teaching_id)
      @plans = Plan.where(teaching_id: teaching_id).order('serial')
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, notice: '课程或教学计划出错'}
      end 
    end
  end

  # GET /plans/1
  # GET /plans/1.json
  def show
    unless current_user.has_role? :admin
    respond_to do |format|
        format.html { redirect_to plans_path}
      end 
    end 
  end

  # GET /plans/new
  def new
    @plan = Plan.new
  end

  # GET /plans/1/edit
  def edit
  end

  # POST /plans
  # POST /plans.json
  def create
    @plan = Plan.new(plan_params)
    @plan.teaching_id = session[:teaching_id]
    @plan.user_id = current_user.id

    respond_to do |format|
      if @plan.save
        format.html { redirect_to @plan, notice: "教学计划已被成功创建" }
        format.json { render :show, status: :created, location: @plan }
      else
        format.html { render :new }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plans/1
  # PATCH/PUT /plans/1.json
  def update
    respond_to do |format|
      if @plan.update(plan_params)
        format.html { redirect_to @plan, notice: "教学计划已被成功更新" }
        format.json { render :show, status: :ok, location: @plan }
      else
        format.html { render :edit }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plans/1
  # DELETE /plans/1.json
  def destroy
    @plan.destroy
    respond_to do |format|
      format.html { redirect_to plans_url, notice: "教学计划已被成功删除" }
      format.json { head :no_content }
    end
  end

  # GET /talkshow_yml?teaching_id=123
  def talkshow_yml
    if params[:teaching_id]
      teaching_id = params[:teaching_id]
      @teaching = Teaching.find(teaching_id)
      @lesson = Lesson.find(@teaching.lesson_id)
      @plans = Plan.where(teaching_id: teaching_id).order('serial')
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, notice: '需要指定一个教学计划'}
      end 
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plan
      @plan = Plan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def plan_params
      params.require(:plan).permit(:serial, :user_id, :teaching_id, :tutor_id)
    end

    def be_a_master
      unless Master.find_by(user_id: current_user.id)
        redirect_back fallback_location: root_path, notice: "对不起，您暂时还没有老师的身份，无法进行操作。"
      end
    end

end
