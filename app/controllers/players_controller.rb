class PlayersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_player, only: [:show, :edit, :update, :destroy]

  # GET /players
  # GET /players.json
  def index
    if current_user.has_role? :admin
      @players = Player.all
    else
      @team = Team.find_by(id: session[:team_id])
      @players = Player.where(team_id: @team.id).order(:member_id)
    end
  end

  # GET /players/1
  # GET /players/1.json
  def show
  end

  # GET /players/new
  def new
    @player = Player.new
  end

  # GET /players/1/edit
  def edit
  end

  # POST /players
  # POST /players.json
  def create
    if current_user.has_role? :admin
      @player = Player.new(player_params)

      respond_to do |format|
        if @player.save
          format.html { redirect_to @player, notice: 'Player was successfully created.' }
          format.json { render :show, status: :created, location: @player }
        else
          format.html { render :new }
          format.json { render json: @player.errors, status: :unprocessable_entity }
        end
      end
    else
=begin
      @player = Player.new(player_params)
      @player.user_id = current_user.id
      @player.team_id = session[:team_id]
      respond_to do |format|
        if @player.save
          format.html { redirect_to players_url, notice: 'Player was successfully created.' }
          format.json { render :show, status: :created, location: @player }
        else
          format.html { render :new }
          format.json { render json: @player.errors, status: :unprocessable_entity }
        end
      end
=end
      player_params[:member_id].to_a.each { |member|
        next if member == ""
        @player = Player.new { |p|
          p.user_id = current_user.id
          p.team_id = session[:team_id] if session[:team_id]
          p.member_id = member.to_i
        }
        @player.save!
      }
      respond_to do |format|
          format.html { redirect_to players_url, notice: '成功添加小组成员' }
      end
    end
  end

  # PATCH/PUT /players/1
  # PATCH/PUT /players/1.json
  def update
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to players_url, notice: 'Player was successfully updated.' }
        # format.html { redirect_to @player, notice: 'Player was successfully updated.' }
        format.json { render :show, status: :ok, location: @player }
      else
        format.html { render :edit }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.json
  def destroy
    @player.destroy
    respond_to do |format|
      format.html { redirect_to players_url, notice: 'Player was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def player_params
      params.require(:player).permit(:user_id, :team_id, {member_id: []}, :deleted_at)
    end
end
