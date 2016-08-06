class PacesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_pace, only: [:show, :edit, :update, :destroy]
  autocomplete :lesson, :title, full: true, :display_value => :funky_method, extra_data: [:id]

  # GET /paces
  # GET /paces.json
  def index
    if current_user.has_role? :admin
      @paces = Pace.all
    elsif session[:roadmap_id]
      @roadmap = Roadmap.find(session[:roadmap_id])
      @paces = Pace.where(roadmap_id: @roadmap.id).order(:serial)
    else
      redirect_to roadmaps_url, notice: "请先指定一条文路。"
    end

  end

  # GET /paces/1
  # GET /paces/1.json
  def show
  end

  # GET /paces/new
  def new
    @pace = Pace.new
  end

  # GET /paces/1/edit
  def edit
  end

  # POST /paces
  # POST /paces.json
  def create
    @pace = Pace.new(pace_params)
    @pace.roadmap_id =  session[roadmap_id]
    @pace.user_id = current_user.id

    respond_to do |format|
      if @pace.save
        format.html { redirect_to @pace, notice: 'Pace was successfully created.' }
        format.json { render :show, status: :created, location: @pace }
      else
        format.html { render :new }
        format.json { render json: @pace.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /paces/1
  # PATCH/PUT /paces/1.json
  def update
    respond_to do |format|
      if @pace.update(pace_params)
        format.html { redirect_to @pace, notice: 'Pace was successfully updated.' }
        format.json { render :show, status: :ok, location: @pace }
      else
        format.html { render :edit }
        format.json { render json: @pace.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /paces/1
  # DELETE /paces/1.json
  def destroy
    @pace.destroy
    respond_to do |format|
      format.html { redirect_to paces_url, notice: 'Pace was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # 在教科书中选择即将添加到文路中的课程。
  def choose_a_textbook
    @roadmap = Roadmap.find(session[:roadmap_id])
    @textbook = Textbook.find(params[:textbook_id])
    @catalogs = @textbook.catalogs.order(:serial)
  end

  # 批量将课程添加到文路中。
  def load_from_textbook
    begin
      @roadmap = Roadmap.find(session[:roadmap_id])
      params[:lesson_id].each do |lesson|
        Pace.create {|pace|
          pace.user_id = current_user.id
          pace.roadmap_id = @roadmap.id
          pace.lesson_id = lesson
          if @roadmap.paces.any?
            pace.serial = @roadmap.paces.order(:serial).last.serial + 1
          else
            pace.serial = 1
          end
        }
      end
      respond_to do |format|
        format.html { redirect_to paces_path, notice: '成功将课程追加到文路中。' }
        format.json { render :show, status: :created, location: @card }
      end
    rescue
      respond_to do |format|
        format.html { redirect_to paces_path, notice: '添加出错，请检查哪些课程没有添加。' }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pace
      @pace = Pace.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pace_params
      params.require(:pace).permit(:user_id, :roadmap_id, :lesson_id, :serial, :deleted_at)
    end
end
