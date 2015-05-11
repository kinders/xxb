class JusticesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_justice, only: [:show, :edit, :update, :destroy]

  # GET /justices
  # GET /justices.json
  def index
    if current_user.has_role? :admin
      @justices = Justice.all
    else
      @justices = Justice.where(user_id: current_user.id).order(updated_at: :desc)
    end
  end

  # GET /justices/1
  # GET /justices/1.json
  def show
  end

  # GET /justices/new
  def new
    if current_user.has_role? :admin
      @justice = Justice.new
    else
      @evaluation = Evaluation.find(session[:evaluation_id])
      old_justice = Justice.find_by(evaluation_id: @evaluation.id)
      #  禁止评点自己的答卷
      if @evaluation.user_id == current_user.id
	respond_to do |format|
	  format.html{ redirect_to evaluation_path(@evaluation), notice: "这是自己的答卷，应请其他用户评分"}
	end
      elsif old_justice && old_justice.user_id == 1 
	  respond_to do |format|
	    format.html{ redirect_to evaluation_path(@evaluation), notice: "该答卷符合标准答案，不能更改评分"}
	  end
      else
        #  如果评过该答卷，则跳转到"编辑"页面中
        @justice = Justice.find_by(evaluation_id: @evaluation.id, user_id: current_user.id)
        if @justice
	  respond_to do |format|
	    format.html{ redirect_to edit_justice_path(@justice.id), notice: "该答卷已经评过，您可以更改之前的评价"}
	  end
        else
          @justice = Justice.new
          @justice.title = @evaluation.title
          @justice.question = @evaluation.question
          @justice.answer = @evaluation.answer
          @justice.your_answer = @evaluation.your_answer
          @justice.practice_score = @evaluation.practice_score
          @justice.practice_id = @evaluation.practice_id
        end
      end
    end
  end

  # GET /justices/1/edit
  def edit
  end

  # POST /justices
  # POST /justices.json
  def create
    @justice = Justice.new(justice_params)
    unless current_user.has_role? :admin
      @justice.user_id = current_user.id
      @evaluation = Evaluation.find(session[:evaluation_id])
      @justice.evaluation_id = @evaluation.id
      @justice.evaluation_user_id = @evaluation.user_id
      @justice.title = @evaluation.title
      @justice.question = @evaluation.question
      @justice.answer = @evaluation.answer
      @justice.your_answer = @evaluation.your_answer
      @justice.practice_score = @evaluation.practice_score
      @justice.practice_id = @evaluation.practice_id
    end
    respond_to do |format|
      if @justice.save
        format.html { redirect_to @justice, notice: '评分成功' }
        format.json { render :show, status: :created, location: @justice }
      else
        format.html { render :new }
        format.json { render json: @justice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /justices/1
  # PATCH/PUT /justices/1.json
  def update
    unless current_user.has_role? :admin
      @evaluation = Evaluation.find(@justice.evaluation_id)
    end
    respond_to do |format|
      if @justice.update(justice_params)
        format.html { redirect_to @justice, notice: '评分已经更新' }
        format.json { render :show, status: :ok, location: @justice }
      else
        format.html { render :edit }
        format.json { render json: @justice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /justices/1
  # DELETE /justices/1.json
  def destroy
    @justice.destroy
    respond_to do |format|
      format.html { redirect_to justices_url, notice: '评分已被删除' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_justice
      @justice = Justice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def justice_params
      params.require(:justice).permit(:score, :remark, :activity, :user_id, :evaluation_id, :title, :question, :answer, :your_answer, :practice_score, :evaluation_user_id, :practice_id)
    end
end
