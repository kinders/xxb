class ObservationsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_observation, only: [:show, :edit, :update, :destroy]
  before_action :be_a_master, except: [:index, :show]

  # GET /observations
  # GET /observations.json
  def index
    if current_user.has_role? :admin 
      @observations = Observation.all
    else
      @observations = Observation.where(user_id: current_user.id).order(created_at: :desc)
    end
  end

  # GET /observations/1
  # GET /observations/1.json
  def show
  end

  # GET /observations/new
  def new
    if current_user.has_role? :admin 
      @observation = Observation.new
    else
      @observation = Observation.new
      @homework = Homework.find(session[:homework_id])
      @observation.student = @homework.student if @homework.student
    end
  end

  # GET /observations/1/edit
  def edit
  end

  # POST /observations
  # POST /observations.json
  def create
    if current_user.has_role? :admin 
    @observation = Observation.new(observation_params)
    else
    @homework = Homework.find(session[:homework_id])
    @observation = Observation.new(observation_params)
    @observation.user_id = current_user.id
    @observation.student ||= @homework.student
    @observation.homework_id = @homework.id
    end

    respond_to do |format|
      if @observation.save
        format.html { redirect_to @observation, notice: 'Observation was successfully created.' }
        format.json { render :show, status: :created, location: @observation }
      else
        format.html { render :new }
        format.json { render json: @observation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /observations/1
  # PATCH/PUT /observations/1.json
  def update
    respond_to do |format|
      if @observation.update(observation_params)
        format.html { redirect_to @observation, notice: 'Observation was successfully updated.' }
        format.json { render :show, status: :ok, location: @observation }
      else
        format.html { render :edit }
        format.json { render json: @observation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /observations/1
  # DELETE /observations/1.json
  def destroy
    @observation.destroy
    respond_to do |format|
      format.html { redirect_to observations_url, notice: 'Observation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_observation
      @observation = Observation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def observation_params
      params.require(:observation).permit(:user_id, :student, :point, :mark, :deleted_at, :homework_id)
    end

    def be_a_master
      unless Master.find_by(user_id: current_user.id)
        redirect_to :back, notice: "对不起，您暂时还没有老师的身份，无法进行操作。"
      end
    end

end
