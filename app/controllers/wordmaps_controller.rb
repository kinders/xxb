class WordmapsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_wordmap, only: [:show, :edit, :update, :destroy]

  # GET /wordmaps
  # GET /wordmaps.json
  def index
    session[:wordmap_id] = nil
    if current_user.has_role? :admin
      @wordmaps = Wordmap.all.order("id")
    elsif session[:roadmap_id]
      @roadmap = Roadmap.find_by(id: session[:roadmap_id])
      @wordmaps = Wordmap.where(user_id: current_user.id, roadmap_id: session[:roadmap_id]).order("id")
    else
      redirect_to roadmaps_url, notice: '请先指定文路'
    end
  end

  # GET /wordmaps/1
  # GET /wordmaps/1.json
  def show
    session[:wordmap_id] = @wordmap.id
    unless current_user.has_role? :admin
      respond_to do |format|
        format.html { redirect_to wordorders_path }
      end
    end
  end

=begin
  # GET /wordmaps/new
  def new
    @wordmap = Wordmap.new
  end

  # GET /wordmaps/1/edit
  def edit
  end

  # POST /wordmaps
  # POST /wordmaps.json
  def create
    @wordmap = Wordmap.new(wordmap_params)

    respond_to do |format|
      if @wordmap.save
        format.html { redirect_to @wordmap, notice: 'Wordmap was successfully created.' }
        format.json { render :show, status: :created, location: @wordmap }
      else
        format.html { render :new }
        format.json { render json: @wordmap.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wordmaps/1
  # PATCH/PUT /wordmaps/1.json
  def update
    respond_to do |format|
      if @wordmap.update(wordmap_params)
        format.html { redirect_to @wordmap, notice: 'Wordmap was successfully updated.' }
        format.json { render :show, status: :ok, location: @wordmap }
      else
        format.html { render :edit }
        format.json { render json: @wordmap.errors, status: :unprocessable_entity }
      end
    end
  end
=end

  # DELETE /wordmaps/1
  # DELETE /wordmaps/1.json
  def destroy
    @wordmap.destroy
    respond_to do |format|
      format.html { redirect_to wordmaps_url, notice: 'Wordmap was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wordmap
      @wordmap = Wordmap.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wordmap_params
      params.require(:wordmap).permit(:user_id, :roadmap_id, :name, :deleted_at)
    end
end
