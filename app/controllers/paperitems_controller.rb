class PaperitemsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_paperitem, only: [:show, :edit, :update, :destroy]
  before_action :be_a_master, except: [:index, :show]

  # GET /paperitems
  # GET /paperitems.json
  def index
    if current_user.has_role? :admin
      @paperitems = Paperitem.all
    else
      @paper = Paper.find(session[:paper_id])
      @paperitems = Paperitem.where(paper_id: @paper.id)
      if session[:papertest_id] == nil && current_user.id != @paper.user_id
        @papertest = Papertest.create{|pt|
          pt.user_id = current_user.id
          pt.paper_id = @paper.id
          pt.end_at = Time.now + @paper.duration * 60
        }
        session[:papertest_id] = @papertest.id
      else
        @papertest = Papertest.find(session[:papertest_id]) if session[:papertest_id]
      end
    end
  end

  # GET /paperitems/1
  # GET /paperitems/1.json
  def show
    if current_user.has_role? :admin
    else
      session[:paperitem_id] = @paperitem.id
      redirect_to paperitems_url
    end
  end

  # GET /paperitems/new
  def new
    if current_user.has_role? :admin
      @paperitem = Paperitem.new
    else
      redirect_to textbooks_url, notice: "请进入课程的习题库中，点击右上角的功能按钮，添加测验题目。"
    end
  end

  # GET /paperitems/1/edit
  def edit
  end

  # POST /paperitems
  # POST /paperitems.json
  def create
    @paperitem = Paperitem.new(paperitem_params)

    respond_to do |format|
      if @paperitem.save
        format.html { redirect_to @paperitem, notice: 'Paperitem was successfully created.' }
        format.json { render :show, status: :created, location: @paperitem }
      else
        format.html { render :new }
        format.json { render json: @paperitem.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /paperitems/1
  # PATCH/PUT /paperitems/1.json
  def update
    respond_to do |format|
      if @paperitem.update(paperitem_params)
        format.html { redirect_to @paperitem, notice: 'Paperitem was successfully updated.' }
        format.json { render :show, status: :ok, location: @paperitem }
      else
        format.html { render :edit }
        format.json { render json: @paperitem.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /paperitems/1
  # DELETE /paperitems/1.json
  def destroy
    @paperitem.destroy
    respond_to do |format|
      format.html { redirect_to paperitems_url, notice: 'Paperitem was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_paperitem
      @paperitem = Paperitem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def paperitem_params
      params.require(:paperitem).permit(:user_id, :paper_id, :practice_id, :score, :serial, :deleted_at)
    end

    def be_a_master
      unless Master.find_by(user_id: current_user.id)
        redirect_to :back, notice: "对不起，您暂时还没有老师的身份，无法进行操作。"
      end
    end

end
