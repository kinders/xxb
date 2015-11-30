class ClasspersonscoresController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_classpersonscore, only: [:show, :edit, :update, :destroy]

  # GET /classpersonscores
  # GET /classpersonscores.json
  def index
    @classpersonscores = Classpersonscore.all
  end

  # GET /classpersonscores/1
  # GET /classpersonscores/1.json
  def show
  end

  # GET /classpersonscores/new
  def new
    @classpersonscore = Classpersonscore.new
  end

  # GET /classpersonscores/1/edit
  def edit
  end

  # POST /classpersonscores
  # POST /classpersonscores.json
  def create
    @classpersonscore = Classpersonscore.new(classpersonscore_params)

    respond_to do |format|
      if @classpersonscore.save
        format.html { redirect_to @classpersonscore, notice: 'Classpersonscore was successfully created.' }
        format.json { render :show, status: :created, location: @classpersonscore }
      else
        format.html { render :new }
        format.json { render json: @classpersonscore.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /classpersonscores/1
  # PATCH/PUT /classpersonscores/1.json
  def update
    respond_to do |format|
      if @classpersonscore.update(classpersonscore_params)
        format.html { redirect_to @classpersonscore, notice: 'Classpersonscore was successfully updated.' }
        format.json { render :show, status: :ok, location: @classpersonscore }
      else
        format.html { render :edit }
        format.json { render json: @classpersonscore.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /classpersonscores/1
  # DELETE /classpersonscores/1.json
  def destroy
    @classpersonscore.destroy
    respond_to do |format|
      format.html { redirect_to classpersonscores_url, notice: 'Classpersonscore was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_classpersonscore
      @classpersonscore = Classpersonscore.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def classpersonscore_params
      params.require(:classpersonscore).permit(:user_id, :member_id, :score, :classgroupscore_id, :deleted_at)
    end
end
