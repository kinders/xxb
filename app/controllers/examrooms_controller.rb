class ExamroomsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_examroom, only: [:show, :edit, :update, :destroy]
  before_action :be_a_master, except: [:index, :show]

  # GET /examrooms
  # GET /examrooms.json
  def index
    session[:examroom_id] = nil
    if current_user.has_role? :admin
      @examrooms = Examroom.all
    else
      @classroom = Classroom.find(session[:classroom_id])
      @examrooms = Examroom.where(classroom_id: @classroom.id).order(isactive: :desc)
    end
  end

  # GET /examrooms/1
  # GET /examrooms/1.json
  def show
    session[:examroom_id] = @examroom.id
    if current_user.has_role? :admin
    else
      @classroom = @examroom.classroom
      @paper = @examroom.paper
      session[:paper_id] = @paper.id
    end
  end

  # GET /examrooms/new
  def new
    if current_user.has_role? :admin
      @examroom = Examroom.new
    else
      @examroom = Examroom.new
    end
  end

  # GET /examrooms/1/edit
  def edit
    if current_user.has_role? :admin
    else
    end
  end

  # POST /examrooms
  # POST /examrooms.json
  def create
    @examroom = Examroom.new(examroom_params)
    @examroom.user_id = current_user.id
    @examroom.classroom_id = session[:classroom_id]

    respond_to do |format|
      if @examroom.save
        format.html { redirect_to @examroom, notice: 'Examroom was successfully created.' }
        format.json { render :show, status: :created, location: @examroom }
      else
        format.html { render :new }
        format.json { render json: @examroom.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /examrooms/1
  # PATCH/PUT /examrooms/1.json
  def update
    respond_to do |format|
      if @examroom.update(examroom_params)
        format.html { redirect_to @examroom, notice: 'Examroom was successfully updated.' }
        format.json { render :show, status: :ok, location: @examroom }
      else
        format.html { render :edit }
        format.json { render json: @examroom.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /examrooms/1
  # DELETE /examrooms/1.json
  def destroy
    @examroom.destroy
    respond_to do |format|
      format.html { redirect_to examrooms_url, notice: 'Examroom was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_examroom
      @examroom = Examroom.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def examroom_params
      params.require(:examroom).permit(:user_id, :classroom_id, :paper_id, :deleted_at, :isactive)
    end

    def be_a_master
      unless Master.find_by(user_id: current_user.id)
        redirect_to :back, notice: "对不起，您暂时还没有老师的身份，无法进行操作。"
      end
    end

end
