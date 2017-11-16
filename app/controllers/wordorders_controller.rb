class WordordersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_wordorder, only: [:show, :edit, :update, :destroy]

  # GET /wordorders
  # GET /wordorders.json
  def index
    if current_user.has_role? :admin
      @wordorders = Wordorder.all
    elsif session[:wordmap_id]
      @wordmap = wordmap.find(session[:wordmap_id])
      @wordorders = Wordorder.where(user_id: current_user.id, wordmap_id: @wordmap.id).order(:serial)
    else
      redirect_to roadmaps_url, notice: "请先指定文路和词序表。"
  end

=begin
  # GET /wordorders/1
  # GET /wordorders/1.json
  def show
  end

  # GET /wordorders/new
  def new
    @wordorder = Wordorder.new
  end

  # GET /wordorders/1/edit
  def edit
  end

  # POST /wordorders
  # POST /wordorders.json
  def create
    @wordorder = Wordorder.new(wordorder_params)

    respond_to do |format|
      if @wordorder.save
        format.html { redirect_to @wordorder, notice: 'Wordorder was successfully created.' }
        format.json { render :show, status: :created, location: @wordorder }
      else
        format.html { render :new }
        format.json { render json: @wordorder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wordorders/1
  # PATCH/PUT /wordorders/1.json
  def update
    respond_to do |format|
      if @wordorder.update(wordorder_params)
        format.html { redirect_to @wordorder, notice: 'Wordorder was successfully updated.' }
        format.json { render :show, status: :ok, location: @wordorder }
      else
        format.html { render :edit }
        format.json { render json: @wordorder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wordorders/1
  # DELETE /wordorders/1.json
  def destroy
    @wordorder.destroy
    respond_to do |format|
      format.html { redirect_to wordorders_url, notice: 'Wordorder was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
=end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wordorder
      @wordorder = Wordorder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wordorder_params
      params.require(:wordorder).permit(:user_id, :wordmap_id, :word_id, :serial, :deleted_at)
    end
end
