class TeamsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  # GET /teams
  # GET /teams.json
  def index
    if current_user.has_role? :admin
      @teams = Team.all
    else
      @sectionalization = Sectionalization.find(session[:sectionalization_id])
      @teams = Team.where(sectionalization_id: @sectionalization.id)
      @i_am_the_member = Member.find_by(student: current_user.id)
    end
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    unless current_user.has_role? :admin
      session[:team_id] = @team.id
      redirect_to players_path
    end
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create
    if current_user.has_role? :admin
      @team = Team.new(team_params)

      respond_to do |format|
        if @team.save
          format.html { redirect_to @team, notice: 'Team was successfully created.' }
          format.json { render :show, status: :created, location: @team }
        else
          format.html { render :new }
          format.json { render json: @team.errors, status: :unprocessable_entity }
        end
      end
    else
      @team = Team.new(team_params)
      @team.user_id = current_user.id
      @team.sectionalization_id = session[:sectionalization_id]

      respond_to do |format|
        if @team.save
          format.html { redirect_to @team, notice: 'Team was successfully created.' }
          format.json { render :show, status: :created, location: @team }
        else
          format.html { render :new }
          format.json { render json: @team.errors, status: :unprocessable_entity }
        end
      end

    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def join_team
    @team = Team.find(params[:team_id])
    @player = Player.new{|p|
      p.user_id = current_user.id
      p.team_id = @team.id
      p.member_id = Member.find_by(student: current_user.id, classroom_id: session[:classroom_id]).id
    }
    respond_to do |format|
      if @player.save
        format.html { redirect_to teams_url, notice: "您已经成功加入“#{@team.name}”小组"}
      else
        format.html { redirect_back fallback_location: root_path, notice: "加入小组失败，请重试或者联系管理员" }
      end
    end
  end

  def exit_team
    @team = Team.find(params[:team_id])
    @player = Player.find_by(team_id: @team, user_id: current_user.id, member_id: Member.find_by(student: current_user.id, classroom_id: session[:classroom_id]))
    @player.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: "您已经成功从“#{@team.name}”小组退出"}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:user_id, :sectionalization_id, :name, :deleted_at)
    end
end
