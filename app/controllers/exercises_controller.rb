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
      @exercises = Exercise.where(tutor_id: @tutor.id).order(:serial)
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

  def new_many_exercises
    @lesson = Lesson.find(session[:lesson_id])
    @tutor = Tutor.find(session[:tutor_id])
    @practices = Practice.where(lesson_id: @lesson.id)
  end

  # post add_many_practices
  def add_many_practices
    begin
      @tutor = Tutor.find(session[:tutor_id])
      last_exercise = Exercise.where(tutor_id: @tutor.id).order(:serial).last
      if last_exercise
        last_exercise_serial = last_exercise.serial
      else
        last_exercise_serial = 0
      end
      Practice.where(id: params[:practice_id]).each do |p|
        Exercise.create { |e| 
          e.user_id = current_user.id
          e.tutor_id = @tutor.id
          e.serial  =  last_exercise_serial + 1 
          e.practice_id = p.id
        }
        last_exercise_serial += 1
      end
      respond_to do |format|
        format.html { redirect_to tutor_path(@tutor), notice: '成功将所有选择的习题添加到本辅导中。' }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    rescue 
      respond_to do |format|
        format.html { redirect_to :back, notice: '习题添加失败，请到先检查哪些习题没有添加。' }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # post import_exercises_from_cardbox
  def import_exercises_from_cardbox
    begin
      @cardbox = Cardbox.find(params[:cardbox_id])
      @tutor = Tutor.find(session[:tutor_id])
      last_exercise = Exercise.where(tutor_id: @tutor.id).last
      if last_exercise
        last_exercise_serial = last_exercise.serial
      else
        last_exercise_serial = 0
      end
      @cardbox.cards.each {|card|
        Exercise.create {|e|
          e.user_id = current_user.id
          e.tutor_id = @tutor.id
          e.serial = last_exercise_serial + 1
          e.practice_id = card.practice_id
        }
        last_exercise_serial =+ 1
      }
      respond_to do |format|
        format.html { redirect_to :back, notice: '卡片盒里的习题已经被成功添加到这个辅导中。' }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    rescue
      respond_to do |format|
        format.html { redirect_to :back, notice: '卡片导入出错，请在辅导中检查哪些习题没有被添加。' }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # get export_exercises_to_cardbox
  def export_exercises_to_cardbox
    begin
      @tutor = Tutor.find(session[:tutor_id])
      if @tutor.exercises.any?
        @cardbox = Cardbox.create { |c|
          c.user_id = current_user.id
          c.name = @tutor.title + Time.now.strftime("%F %T")
          c.lesson_id = @tutor.lesson_id
        }
        @tutor.exercises.each_with_index {|e, i|
          Card.create {|card|
            card.user_id = current_user.id
            card.practice_id = e.practice_id
            card.cardbox_id = @cardbox.id
            card.degree = 0
            card.nexttime = Time.now
            card.foul = 0
            card.count = 0
            card.sequence =  i + 1
            card.serial = card.sequence.to_f + card.sequence.to_f / 10000
          }
        }
        respond_to do |format|
          format.html { redirect_to :back, notice: "习题已经被成功添加到卡片盒“#{@cardbox.name}”中。" }
          format.json { render json: @card.errors, status: :unprocessable_entity }
        end
      else
        respond_to do |format|
          format.html { redirect_to :back, notice: '这个辅导里面没有习题，请先添加习题' }
          format.json { render json: @card.errors, status: :unprocessable_entity }
        end
      end
    rescue
      respond_to do |format|
        format.html { redirect_to :back, notice: '习题添加出错，请在卡片盒中检查哪些习题没有被添加到卡片盒中。' }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exercise
      @exercise = Exercise.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exercise_params
      params.require(:exercise).permit(:user_id, :tutor_id, :serial, :practice_id, {practice_id: []})
    end

    def be_a_master
      unless Master.find_by(user_id: current_user.id)
        redirect_to :back, notice: "对不起，您暂时还没有老师的身份，无法进行操作。"
      end
    end

end
