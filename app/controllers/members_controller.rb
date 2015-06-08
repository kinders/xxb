class MembersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_member, only: [:show, :edit, :update, :destroy]

  # GET /members
  # GET /members.json
  def index
    if current_user.has_role? :admin
      @members = Member.all
    else
      @classroom = Classroom.find(session[:classroom_id])
      @members = @classroom.members.order(:serial)
    end
  end

  # GET /members/1
  # GET /members/1.json
  def show
    session[:member_id] = @member.id
    # 下面是未完成作业管理
    @special_homeworks = Homework.where(student: @member.student).order(created_at: :desc).to_a.delete_if { |hw| Observation.find_by(homework_id: hw.id, student: @member.student) }
    @class_homeworks = Homework.where(classroom_id: session[:classroom_id]).order(created_at: :desc).to_a.delete_if { |hw| Observation.find_by(homework_id: hw.id, student: @member.student) }
  end

  # GET /members/new
  def new
    @member = Member.new
  end

  # GET /members/1/edit
  def edit
  end

  # POST /members
  # POST /members.json
  def create
    @member = Member.new(member_params)
    unless current_user.has_role? :admin
      @member.classroom_id = session[:classroom_id]
      @member.user_id = current_user.id
    end
    respond_to do |format|
      if @member.save
        format.html { redirect_to @member, notice: '该成员添加成功！' }
        format.json { render :show, status: :created, location: @member }
      else
        format.html { render :new }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to @member, notice: '成员修改成功！' }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @member.destroy
    respond_to do |format|
      format.html { redirect_to members_url, notice: '成员已被删除！' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def member_params
      params.require(:member).permit(:serial, :user_id, :classroom_id, :deleted_at, :student)
    end
end
