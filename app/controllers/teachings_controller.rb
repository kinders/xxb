class TeachingsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_teaching, only: [:show, :edit, :update, :destroy]
  before_action :be_a_master, except: [:index, :show]

  # GET /teachings
  # GET /teachings.json
  def index
    if current_user.has_role? :admin
      @teachings = Teaching.all
    else 
      @lesson = Lesson.find(session[:lesson_id])
      @teachings = Teaching.where(lesson_id: session[:lesson_id])
    end
  end

  # GET /teachings/1
  # GET /teachings/1.json
  def show
    session[:teaching_id] = @teaching.id
    unless current_user.has_role? :admin
      respond_to do |format|
        format.html { redirect_to plans_path }
      end
    end
  end

  # GET /teachings/new
  def new
    @teaching = Teaching.new
  end

  # GET /teachings/1/edit
  def edit
  end

  # POST /teachings
  # POST /teachings.json
  def create
    @teaching = Teaching.new(teaching_params)
    @teaching.user_id = current_user.id
    @teaching.lesson_id = session[:lesson_id]

    respond_to do |format|
      if @teaching.save
        format.html { redirect_to @teaching, notice: "教学已被成功创建" }
        format.json { render :show, status: :created, location: @teaching }
      else
        format.html { render :new }
        format.json { render json: @teaching.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teachings/1
  # PATCH/PUT /teachings/1.json
  def update
    respond_to do |format|
      if @teaching.update(teaching_params)
        format.html { redirect_to @teaching, notice: "教学已被成功更新" }
        format.json { render :show, status: :ok, location: @teaching }
      else
        format.html { render :edit }
        format.json { render json: @teaching.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teachings/1
  # DELETE /teachings/1.json
  def destroy
    @teaching.destroy
    respond_to do |format|
      format.html { redirect_to teachings_url, notice: "教学已被成功删除" }
      format.json { head :no_content }
    end
  end

  # GET quit
  def quit
    session[:teaching_id] = nil
    redirect_back fallback_location: root_path, notice: '您已经成功退出当前教案安排。'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teaching
      @teaching = Teaching.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def teaching_params
      params.require(:teaching).permit(:user_id, :lesson_id, :title)
    end

    def be_a_master
      unless Master.find_by(user_id: current_user.id)
        redirect_back fallback_location: root_path, notice: "对不起，您暂时还没有老师的身份，无法进行操作。"
      end
    end

end
