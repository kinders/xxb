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
      @paperitems = Paperitem.where(paper_id: @paper.id).order(:serial)
      ## 如果已经有了测验会话，则继续测验
      if session[:papertest_id]
      @papertest = Papertest.find(session[:papertest_id])
      ## 如果没有测验会话
      else
        ### 并且不是出卷人，则新建测验会话开始测验。
        if @paper.user_id != current_user.id
          unless Master.find_by(id: current_user.id)
            @papertest = Papertest.create{|pt|
              pt.user_id = current_user.id
              pt.paper_id = @paper.id
              pt.end_at = Time.now + @paper.duration * 60
            }
            session[:papertest_id] = @papertest.id
          end
        end
      end
    end
  end

  # GET /paperitems/1
  # GET /paperitems/1.json
  def show
    if current_user.has_role? :admin
    else
      session[:paperitem_id] = @paperitem.id
      @paper = @paperitem.paper
      @papertest_ids = @paper.papertests.map{|p|p.id}
      @evaluations = Evaluation.where(practice_id: @paperitem.practice_id, papertest: @papertest_ids).order(id: :desc)
      # 下面生成“上一题”和“下一题”
      all_paperitem_ids = Paperitem.where(paper_id: @paper.id).order(:serial).pluck(:id)
      index = all_paperitem_ids.find_index(@paperitem.id)
      if index - 1 < 0
	      @previous_paperitem = nil  
	    else
	      previous_paperitem = all_paperitem_ids[index - 1]
	      @previous_paperitem = Paperitem.find(previous_paperitem)
	    end
	    if index + 1 == all_paperitem_ids.length
	      @next_paperitem = nil
	    else
	      next_paperitem = all_paperitem_ids[index + 1]
	      @next_paperitem = Paperitem.find(next_paperitem)
	    end
    end
  end

  # GET /paperitems/new
  def new
    @paperitem = Paperitem.new
  end

  # GET /paperitems/1/edit
  def edit
  end

  # POST /paperitems
  # POST /paperitems.json
  def create
    @paperitem = Paperitem.new(paperitem_params)
    unless @paperitem.practice_id
      @paperitem.practice_id = 0
      @paperitem.user_id = current_user.id
      @paperitem.paper_id = session[:paper_id]
      @paperitem.score = 0
    end
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
      params.require(:paperitem).permit(:user_id, :paper_id, :practice_id, :score, :serial, :memo, :deleted_at)
    end

    def be_a_master
      unless Master.find_by(user_id: current_user.id)
        redirect_to :back, notice: "对不起，您暂时还没有老师的身份，无法进行操作。"
      end
    end

end
