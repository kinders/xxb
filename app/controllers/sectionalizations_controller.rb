class SectionalizationsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_sectionalization, only: [:show, :edit, :update, :destroy]

  # GET /sectionalizations
  # GET /sectionalizations.json
  def index
    if current_user.has_role? :admin
      @sectionalizations = Sectionalization.all
    else
      @classroom = Classroom.find(session[:classroom_id])
      @sectionalizations = Sectionalization.where(classroom_id: @classroom.id)
      session[:sectionalization_id] = nil
    end
  end

  # GET /sectionalizations/1
  # GET /sectionalizations/1.json
  def show
    unless current_user.has_role? :admin
      session[:sectionalization_id] = @sectionalization.id
      redirect_to teams_path
    end
  end

  # GET /sectionalizations/new
  def new
    @sectionalization = Sectionalization.new
  end

  # GET /sectionalizations/1/edit
  def edit
  end

  # POST /sectionalizations
  # POST /sectionalizations.json
  def create
    if current_user.has_role? :admin
      @sectionalization = Sectionalization.new(sectionalization_params)

      respond_to do |format|
        if @sectionalization.save
          format.html { redirect_to @sectionalization, notice: 'Sectionalization was successfully created.' }
          format.json { render :show, status: :created, location: @sectionalization }
        else
          format.html { render :new }
          format.json { render json: @sectionalization.errors, status: :unprocessable_entity }
        end
      end
    else
      @sectionalization = Sectionalization.new(sectionalization_params)
      @sectionalization.user_id = current_user.id
      @sectionalization.classroom_id = session[:classroom_id]
      respond_to do |format|
        if @sectionalization.save
          format.html { redirect_to @sectionalization, notice: 'Sectionalization was successfully created.' }
          format.json { render :show, status: :created, location: @sectionalization }
        else
          format.html { render :new }
          format.json { render json: @sectionalization.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /sectionalizations/1
  # PATCH/PUT /sectionalizations/1.json
  def update
    respond_to do |format|
      if @sectionalization.update(sectionalization_params)
        format.html { redirect_to @sectionalization, notice: 'Sectionalization was successfully updated.' }
        format.json { render :show, status: :ok, location: @sectionalization }
      else
        format.html { render :edit }
        format.json { render json: @sectionalization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sectionalizations/1
  # DELETE /sectionalizations/1.json
  def destroy
    @sectionalization.destroy
    respond_to do |format|
      format.html { redirect_to sectionalizations_url, notice: 'Sectionalization was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def choose_sectionalization
    session[:sectionalization_id] = params[:sectionalization_id]
    redirect_to :back, notice: "您已经选择了一个分组方案"
  end

  def reset_sectionalization
    session[:sectionalization_id] = nil
    redirect_to :back, notice: "您现在可以重新选择_分组方案_了"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sectionalization
      @sectionalization = Sectionalization.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sectionalization_params
      params.require(:sectionalization).permit(:user_id, :classroom_id, :name, :deleted_at)
    end
end
