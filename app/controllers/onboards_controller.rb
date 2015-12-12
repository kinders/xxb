class OnboardsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_onboard, only: [:show, :edit, :update, :destroy]

  # GET /onboards
  # GET /onboards.json
  def index
    if current_user.has_role? :admin
      @onboards = Onboard.all.page params[:page]
    else
      @onboards = Onboard.where(user_id: current_user.id).page params[:page]
    end
  end

  # GET /onboards/1
  # GET /onboards/1.json
  def show
    redirect_to onboards_path, notice: "你还想怎么看啊？"
  end

  # GET /onboards/new
  def new
    redirect_to onboards_path, notice: "上线信息由系统生成，无法手工建立！"
    #@onboard = Onboard.new
  end

  # GET /onboards/1/edit
  def edit
    redirect_to onboards_path, notice: "上线信息由系统生成，无法手工修改！"
  end

  # POST /onboards
  # POST /onboards.json
  def create
    redirect_to onboards_path, notice: "上线信息由系统生成，无法手工建立！"
    #@onboard = Onboard.new(onboard_params)

    #respond_to do |format|
    #  if @onboard.save
    #    format.html { redirect_to @onboard, notice: 'Onboard was successfully created.' }
    #    format.json { render :show, status: :created, location: @onboard }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @onboard.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /onboards/1
  # PATCH/PUT /onboards/1.json
  def update
    redirect_to onboards_path, notice: "上线信息由系统生成，无法手工修改！"
    #respond_to do |format|
    #  if @onboard.update(onboard_params)
    #    format.html { redirect_to @onboard, notice: 'Onboard was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @onboard }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @onboard.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /onboards/1
  # DELETE /onboards/1.json
  def destroy
    redirect_to onboards_path, notice: "上线信息由系统生成，无法手工删除！"
    #@onboard.destroy
    #respond_to do |format|
    #  format.html { redirect_to onboards_url, notice: 'Onboard was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_onboard
      @onboard = Onboard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def onboard_params
      params.require(:onboard).permit(:user_id, :begin_at, :expire_at, :end_at, :remote_ip, :http_user_agent, :deleted_at)
    end
end
