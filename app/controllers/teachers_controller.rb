class TeachersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_teacher, only: [:show, :edit, :update, :destroy]

  # GET /teachers
  # GET /teachers.json
  def index
    if current_user.has_role? :admin 
      @teachers = Teacher.all
    else
      @classroom = Classroom.find(session[:classroom_id])
      @teachers = Teacher.where(classroom_id: @classroom.id)
    end
  end

  # GET /teachers/1
  # GET /teachers/1.json
  def show
    session[:teacher_id] = @teacher.id
  end

  # GET /teachers/new
  def new
    @teacher = Teacher.new
  end

  # GET /teachers/1/edit
  def edit
  end

  # POST /teachers
  # POST /teachers.json
  def create
    @teacher = Teacher.new(teacher_params)
    @teacher.user_id = current_user.id
    @teacher.classroom_id = session[:classroom_id]

    respond_to do |format|
      if @teacher.save
        format.html { redirect_to @teacher, notice: '成功为班级添加一位老师！' }
        format.json { render :show, status: :created, location: @teacher }
      else
        format.html { render :new }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teachers/1
  # PATCH/PUT /teachers/1.json
  def update
    respond_to do |format|
      if @teacher.update(teacher_params)
        format.html { redirect_to @teacher, notice: 'Teacher was successfully updated.' }
        format.json { render :show, status: :ok, location: @teacher }
      else
        format.html { render :edit }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teachers/1
  # DELETE /teachers/1.json
  def destroy
    @teacher.destroy
    respond_to do |format|
      format.html { redirect_to teachers_url, notice: 'Teacher was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teacher
      @teacher = Teacher.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def teacher_params
      params.require(:teacher).permit(:user_id, :classroom_id, :mentor, :deleted_at, :subject_id)
    end
end
