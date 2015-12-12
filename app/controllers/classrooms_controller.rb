class ClassroomsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_classroom, only: [:show, :edit, :update, :destroy]
  before_action :be_a_master, except: [:index, :show]

  # GET /classrooms
  # GET /classrooms.json
  def index
    if current_user.has_role? :admin
      @classrooms = Classroom.all
    else
      @classrooms = Classroom.where(end: false)
    end
  end

  # GET /classrooms/1
  # GET /classrooms/1.json
  def show
    session[:classroom_id] = @classroom.id
    @member = @classroom.members.find_by(student: current_user.id)
    @teacher = @classroom.teachers.find_by(mentor: current_user.id)
    @cadre = @classroom.cadres.find_by(member_id: @member.id) if @member
    @sectionalization = Sectionalization.find(session[:sectionalization_id]) if session[:sectionalization_id]
    # 班级的不良记录
    ## 如果是班主任
    if @classroom.user_id == current_user.id
      @class_badrecords = Badrecord.where(classroom_id: @classroom.id, finish: nil, troublemaker: @classroom.members.map{|m|m.student}).order(:troublemaker)
    ## 如果是科任教师
    elsif @classroom.teachers.find_by(mentor: current_user.id)
      @class_badrecords = Badrecord.where(classroom_id: @classroom.id, finish: nil, subject_id: @classroom.teachers.find_by(mentor: current_user.id).subject_id, troublemaker: @classroom.members.map{|m|m.student}).order(:troublemaker)
    ## 如果是其他人
    else
      @class_badrecords = []  # 为了在视图中统一使用any?方法。
    end
    
    #unless current_user.has_role? :admin
      #respond_to do |format|
        #format.html { redirect_to members_path }
      #end
    #end
  end

  # GET /classrooms/new
  def new
    @classroom = Classroom.new
  end

  # GET /classrooms/1/edit
  def edit
  end

  # POST /classrooms
  # POST /classrooms.json
  def create
    @classroom = Classroom.new(classroom_params)
    unless current_user.has_role? :admin
      @classroom.user_id = current_user.id
    end

    respond_to do |format|
      if @classroom.save
        format.html { redirect_to @classroom, notice: '新的教室已经成功创建！' }
        format.json { render :show, status: :created, location: @classroom }
      else
        format.html { render :new }
        format.json { render json: @classroom.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /classrooms/1
  # PATCH/PUT /classrooms/1.json
  def update
    respond_to do |format|
      if @classroom.update(classroom_params)
        format.html { redirect_to @classroom, notice: '教室信息成功更新！' }
        format.json { render :show, status: :ok, location: @classroom }
      else
        format.html { render :edit }
        format.json { render json: @classroom.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /classrooms/1
  # DELETE /classrooms/1.json
  def destroy
    @classroom.destroy
    respond_to do |format|
      format.html { redirect_to classrooms_url, notice: '教室已被删除！' }
      format.json { head :no_content }
    end
  end

  def quit_classroom
    session[:classroom_id] = nil
    redirect_to "/", notice: "您已经从班级中退出"
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_classroom
      @classroom = Classroom.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def classroom_params
      params.require(:classroom).permit(:name, :user_id, :end)
    end

    def be_a_master
      unless Master.find_by(user_id: current_user.id)
        redirect_to :back, notice: "对不起，您暂时还没有老师的身份，无法进行操作。"
      end
    end

end
