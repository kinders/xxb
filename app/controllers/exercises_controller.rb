class ExercisesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_exercise, only: [:show, :edit, :update, :destroy]
  before_action :be_a_master, except: [:index, :show]

  # GET /exercises
  # GET /exercises.json
  def index
    if current_user.has_role? :admin 
      @exercises = Exercise.all
    else
      @tutor = Tutor.find(session[:tutor_id])
      @exercises = Exercise.where(tutor_id: @tutor.id)
    end
  end

  # GET /exercises/1
  # GET /exercises/1.json
  def show
  end

  # GET /exercises/new
  def new
    if current_user.has_role? :admin 
      @exercise = Exercise.new
    else
      @exercise = Exercise.new { |e|
        e.tutor_id = session[:tutor_id]
      }
    end
  end

  # GET /exercises/1/edit
  def edit
  end

  # POST /exercises
  # POST /exercises.json
  def create
    if current_user.has_role? :admin
      @exercise = Exercise.new(exercise_params)
    else
      @exercise = Exercise.new(exercise_params)
      @exercise.user_id = current_user.id
      @exercise.tutor_id = session[:tutor_id]
    end

    respond_to do |format|
      if @exercise.save
        format.html { redirect_to @exercise, notice: 'Exercise was successfully created.' }
        format.json { render :show, status: :created, location: @exercise }
      else
        format.html { render :new }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exercises/1
  # PATCH/PUT /exercises/1.json
  def update
    respond_to do |format|
      if @exercise.update(exercise_params)
        format.html { redirect_to @exercise, notice: 'Exercise was successfully updated.' }
        format.json { render :show, status: :ok, location: @exercise }
      else
        format.html { render :edit }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exercises/1
  # DELETE /exercises/1.json
  def destroy
    @exercise.destroy
    respond_to do |format|
      format.html { redirect_to exercises_url, notice: 'Exercise was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exercise
      @exercise = Exercise.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exercise_params
      params.require(:exercise).permit(:user_id, :tutor_id, :serial, :practice_id)
    end

    def be_a_master
      unless Master.find_by(user_id: current_user.id)
        redirect_to :back, notice: "对不起，您暂时还没有老师的身份，无法进行操作。"
      end
    end

end
