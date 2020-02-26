class ClassgroupscoresController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_classgroupscore, only: [:show, :edit, :update, :destroy]

  # GET /classgroupscores
  # GET /classgroupscores.json
  def index
    if current_user.has_role? :admin 
      @classgroupscores = Classgroupscore.all
    else
      @classroom = Classroom.find(session[:classroom_id])
      @sectionalization = Sectionalization.find(session[:sectionalization_id])
      @classgroupscores = Classgroupscore.where(team_id: @sectionalization.teams).reverse
    end
  end

  # GET /classgroupscores/1
  # GET /classgroupscores/1.json
  def show
  end

  # GET /classgroupscores/new
  # def new
  #   @classgroupscore = Classgroupscore.new
  # end

  # GET /classgroupscores/1/edit
  def edit
  end

  # POST /classgroupscores
  # POST /classgroupscores.json
  def create
    if current_user.has_role? :admin
      @classgroupscore = Classgroupscore.new(classgroupscore_params)

      respond_to do |format|
        if @classgroupscore.save
          format.html { redirect_to @classgroupscore, notice: 'Classgroupscore was successfully created.' }
          format.json { render :show, status: :created, location: @classgroupscore }
        else
          format.html { render :new }
          format.json { render json: @classgroupscore.errors, status: :unprocessable_entity }
        end
      end
    else
      @classgroupscore = Classgroupscore.new(classgroupscore_params)
      members_in_team = Team.find(@classgroupscore.team_id).players.collect{|p|p.member}
      @classgroupscore.memo = members_in_team.collect{|member| [member.serial.to_s + "_" + User.find(member.student).name ]}.join(", ")
      respond_to do |format|
        if @classgroupscore.save
          members_in_team.each { |member|
            @classpersonscore = Classpersonscore.new {|c|
              c.user_id = @classgroupscore.user_id
              c.member_id = member.id
              c.score = @classgroupscore.score
              c.classgroupscore_id = @classgroupscore.id
            }
            @classpersonscore.save
          }
          format.html { redirect_back fallback_location: root_path, notice: '成功为小组添加评分！' }
          format.json { render :show, status: :created, location: @classgroupscore }
        else
          format.html { redirect_back fallback_location: root_path, notice: '为小组添加评分失败。' }
          format.json { render json: @classgroupscore.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /classgroupscores/1
  # PATCH/PUT /classgroupscores/1.json
  def update
    if current_user.has_role? :admin 
      respond_to do |format|
        if @classgroupscore.update(classgroupscore_params)
          format.html { redirect_to @classgroupscore, notice: 'Classgroupscore was successfully updated.' }
          format.json { render :show, status: :ok, location: @classgroupscore }
        else
          format.html { render :edit }
          format.json { render json: @classgroupscore.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        if @classgroupscore.update(classgroupscore_params)
          @classgroupscore.classpersonscores.update_all(score: @classgroupscore.score)
          format.html { redirect_to @classgroupscore, notice: 'Classgroupscore was successfully updated.' }
          format.json { render :show, status: :ok, location: @classgroupscore }
        else
          format.html { render :edit }
          format.json { render json: @classgroupscore.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /classgroupscores/1
  # DELETE /classgroupscores/1.json
  def destroy
    @classgroupscore.destroy
    respond_to do |format|
      format.html { redirect_to classgroupscores_url, notice: 'Classgroupscore was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_classgroupscore
      @classgroupscore = Classgroupscore.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def classgroupscore_params
      params.require(:classgroupscore).permit(:user_id, :team_id, :score, :domain, :memo, :deleted_at)
    end
end
