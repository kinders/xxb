class HomeworksController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_homework, only: [:show, :edit, :update, :destroy]

  # GET /homeworks
  # GET /homeworks.json
  def index
    if current_user.has_role? :admin 
      @homeworks = Homework.all
    # 如果是班主任，需要显示所有教师布置的作业
    elsif   session[:teacher_id] && session[:classroom_id]
      @teacher = Teacher.find(session[:teacher_id])
      @classroom = Classroom.find(session[:classroom_id])
      # 自己布置的作业
      @homeworks = Homework.where(user_id: @teacher.mentor, classroom_id: @classroom).order(created_at: :desc)
      if @teacher.subject_id == 1
        # 所有老师布置的全班作业
        @class_homeworks = Homework.where.not(user_id: current_user.id).where(classroom_id: @teacher.classroom_id)
        # 所有老师布置的个别学生作业
        @student_homeworks = []
        @classroom.members.each { |member|
          h = Homework.where.not(user_id: current_user.id).where(student: member.student)#
          if h.any?
            @student_homeworks << h
            @student_homeworks.flatten!
          end
        }
      end
    else
      @homeworks = Homework.all.order(created_at: :desc)
    end
  end

  # GET /homeworks/1
  # GET /homeworks/1.json
  def show
    session[:homework_id] = @homework.id
  end

  # GET /homeworks/new
  def new
    @homework = Homework.new
  end

  # GET /homeworks/1/edit
  def edit
  end

  # POST /homeworks
  # POST /homeworks.json
  def create
    @homework = Homework.new(homework_params)
    @homework.user_id = current_user.id

    respond_to do |format|
      if @homework.save
        format.html { redirect_to @homework, notice: 'Homework was successfully created.' }
        format.json { render :show, status: :created, location: @homework }
      else
        format.html { render :new }
        format.json { render json: @homework.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /homeworks/1
  # PATCH/PUT /homeworks/1.json
  def update
    respond_to do |format|
      if @homework.update(homework_params)
        format.html { redirect_to @homework, notice: 'Homework was successfully updated.' }
        format.json { render :show, status: :ok, location: @homework }
      else
        format.html { render :edit }
        format.json { render json: @homework.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /homeworks/1
  # DELETE /homeworks/1.json
  def destroy
    @homework.destroy
    respond_to do |format|
      format.html { redirect_to homeworks_url, notice: 'Homework was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_homework
      @homework = Homework.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def homework_params
      params.require(:homework).permit(:user_id, :classroom_id, :subject_id, :title, :description, :deleted_at, :student)
    end
end
