class PracticesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_practice, only: [:show, :edit, :update, :destroy]

  # GET /practices
  # GET /practices.json
  def index
    if current_user.has_role? :admin
      @practices = Practice.all
    else
      @lesson = Lesson.find_by(id: session[:lesson_id])
      @tutor = Tutor.find_by(id: session[:tutor_id])
      @practices = Practice.where(tutor_id: session[:tutor_id])
    end
  end

  # GET /practices/1
  # GET /practices/1.json
  def show
    history = History.create { |h| 
      h.user_id = current_user.id
      h.modelname = "practice"
      h.entryid = @practice.id
    }
    session[:practice_id] = @practice.id
    @lesson = Lesson.find_by(id: @practice.lesson_id)
    @tutor = Tutor.find_by(id: @practice.tutor_id)
    @practices = Practice.where(tutor_id: session[:tutor_id])
    @practices.each_with_index do | practice, index |
      if practice == @practice
        if index - 1 < 0
	  @previous_practice = nil  
	else
	  @previous_practice = @practices[index - 1] 
	end
	if index + 1 == @practices.length
	  @next_practice = nil
	else
	  @next_practice = @practices[index + 1]
	end
      end
    end
  end

  # GET /practices/new
  def new
    @practice = Practice.new
  end

  # GET /practices/1/edit
  def edit
  end

  # POST /practices
  # POST /practices.json
  def create
    @practice = Practice.new(practice_params)
    unless current_user.has_role? :admin
    @practice.user_id = current_user.id
    @practice.lesson_id = session[:lesson_id]
    @practice.tutor_id = session[:tutor_id]
    @practice.score = (@practice.answer.to_s.length.to_f / 10).ceil
    end
    respond_to do |format|
      if @practice.save
        format.html { redirect_to @practice, notice: "练习#{@practice.id}已经成功添加" }
        format.json { render :show, status: :created, location: @practice }
      else
        format.html { render :new }
        format.json { render json: @practice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /practices/1
  # PATCH/PUT /practices/1.json
  def update
    unless current_user.has_role? :admin
    @practice.score = (@practice.answer.to_s.length.to_f / 10).ceil
    end
    respond_to do |format|
      if @practice.update(practice_params)
        format.html { redirect_to @practice, notice: "练习#{@practice.id}已经更新成功" }
        format.json { render :show, status: :ok, location: @practice }
      else
        format.html { render :edit }
        format.json { render json: @practice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /practices/1
  # DELETE /practices/1.json
  def destroy
    @practice.destroy
    respond_to do |format|
      format.html { redirect_to practices_url, notice: "练习#{@practice.id}已经被成功删除" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_practice
      @practice = Practice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def practice_params
      params.require(:practice).permit(:title, :question, :answer, :user_id, :tutor_id, :lesson_id, :activate, :score)
    end
end
