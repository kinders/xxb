class PapersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_paper, only: [:show, :edit, :update, :destroy]
  before_action :be_a_master, except: [:index, :show, :overview]

  # GET /papers
  # GET /papers.json
  def index
    if current_user.has_role? :admin
      @papers = Paper.all
    else
      @papers = Paper.all
      session[:paper_id] = nil
    end
  end

  # GET /papers/1
  # GET /papers/1.json
  def show
    if current_user.has_role? :admin
    else
      session[:paper_id] = @paper.id
      @papertests = Papertest.where(paper_id: @paper.id, user_id: current_user.id).order(id: :desc)
    end
  end

  # GET /papers/new
  def new
    @paper = Paper.new
  end

  # GET /papers/1/edit
  def edit
  end

  # POST /papers
  # POST /papers.json
  def create
    if current_user.has_role? :admin
      @paper = Paper.new(paper_params)

      respond_to do |format|
        if @paper.save
          format.html { redirect_to @paper, notice: 'Paper was successfully created.' }
          format.json { render :show, status: :created, location: @paper }
        else
          format.html { render :new }
          format.json { render json: @paper.errors, status: :unprocessable_entity }
        end
      end
    else
      @paper = Paper.new(paper_params)
      @paper.user_id = current_user.id

      respond_to do |format|
        if @paper.save
          format.html { redirect_to @paper, notice: 'Paper was successfully created.' }
          format.json { render :show, status: :created, location: @paper }
        else
          format.html { render :new }
          format.json { render json: @paper.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /papers/1
  # PATCH/PUT /papers/1.json
  def update
    respond_to do |format|
      if @paper.update(paper_params)
        format.html { redirect_to @paper, notice: 'Paper was successfully updated.' }
        format.json { render :show, status: :ok, location: @paper }
      else
        format.html { render :edit }
        format.json { render json: @paper.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /papers/1
  # DELETE /papers/1.json
  def destroy
    @paper.destroy
    respond_to do |format|
      format.html { redirect_to papers_url, notice: 'Paper was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_paper
      @paper = Paper.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def paper_params
      params.require(:paper).permit(:user_id, :title, :duration, :deleted_at)
    end

    def be_a_master
      unless Master.find_by(user_id: current_user.id)
        redirect_to :back, notice: "对不起，您暂时还没有老师的身份，无法进行操作。"
      end
    end

end
