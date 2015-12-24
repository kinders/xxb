class CadresController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_cadre, only: [:show, :edit, :update, :destroy]
  before_action :be_a_master, except: [:index, :show]

  # GET /cadres
  # GET /cadres.json
  def index
    if current_user.has_role? :admin
      @cadres = Cadre.all
    else
      @classroom = Classroom.find(session[:classroom_id])
      @cadres = Cadre.where(classroom_id: session[:classroom_id])
      session[:cadre_id] = nil
    end
  end

  # GET /cadres/1
  # GET /cadres/1.json
  def show
    session[:cadre_id] = @cadre.id
    @classroom = Classroom.find(session[:classroom_id])
  end

  # GET /cadres/new
  def new
    @classroom = Classroom.find(session[:classroom_id])
    @cadre = Cadre.new
    @cadre.classroom_id = session[:classroom_id]
  end

  # GET /cadres/1/edit
  def edit
    @classroom = Classroom.find(session[:classroom_id])
  end

  # POST /cadres
  # POST /cadres.json
  def create
    @cadre = Cadre.new(cadre_params)
    @cadre.user_id = current_user.id
    @cadre.classroom_id = session[:classroom_id]

    respond_to do |format|
      if @cadre.save
        format.html { redirect_to @cadre, notice: '成功添加一个班干' }
        format.json { render :show, status: :created, location: @cadre }
      else
        format.html { render :new }
        format.json { render json: @cadre.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cadres/1
  # PATCH/PUT /cadres/1.json
  def update
    respond_to do |format|
      if @cadre.update(cadre_params)
        format.html { redirect_to @cadre, notice: '成功更新一个班干' }
        format.json { render :show, status: :ok, location: @cadre }
      else
        format.html { render :edit }
        format.json { render json: @cadre.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cadres/1
  # DELETE /cadres/1.json
  def destroy
    @cadre.destroy
    respond_to do |format|
      format.html { redirect_to cadres_url, notice: '成功删除一个班干' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cadre
      @cadre = Cadre.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cadre_params
      params.require(:cadre).permit(:user_id, :position, :member_id, :classroom_id, :team_id, :deleted_at)
    end

    def be_a_master
      unless Master.find_by(user_id: current_user.id)
        redirect_to :back, notice: "对不起，您暂时还没有老师的身份，无法进行操作。"
      end
    end

end
