class EvaluationsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_evaluation, only: [:show, :edit, :update, :destroy]

  # GET /evaluations
  # GET /evaluations.json
  def index
    if current_user.has_role? :admin
      @evaluations = Evaluation.all
    else
      @evaluations = Evaluation.where(user_id: current_user.id).order(updated_at: :desc)
    end

  end

  # GET /evaluations/1
  # GET /evaluations/1.json
  def show
    session[:evaluation_id] = @evaluation.id
    @justices = Justice.where(evaluation_id: @evaluation.id)
  end

  # GET /evaluations/new
  def new
    if current_user.has_role? :admin  # 管理员
      @evaluation = Evaluation.new
    else
      if session[:redo_practice]      # 重做
        @tutor = Tutor.find(session[:tutor_id])
        @practice = Practice.find(session[:practice_id])
        @evaluation = Evaluation.new
        @evaluation.title = @practice.title
        @evaluation.question = @practice.question
        @evaluation.practice_score = @practice.score
        session[:redo_practice] = nil
        flash[:notice] = "旧题重做"
      else                               # 正常
        @tutor = Tutor.find(session[:tutor_id])
        # 随机取出未完全答对的练习题
        @use_practices = []
        @practices = Practice.where(tutor_id: session[:tutor_id])
        @practices.each { | p |
          unless Evaluation.find_by(practice_id: p.id, user_id: current_user.id)
             @use_practices << p
          end
        }
        @practice = @use_practices.sample
        # 根据取题情况进行页面的渲染
        if @practice
          session[:practice_id] = @practice.id
          @evaluation = Evaluation.new
          @evaluation.title = @practice.title
          @evaluation.question = @practice.question
          @evaluation.practice_score = @practice.score
        else                               # 如果没有取出题目
          respond_to do |format|
            format.html { redirect_to tutor_path(@tutor), notice: "暂时没有可用的练习了。"}
	  end
        end
      end
    end
  end

  # GET /evaluations/1/edit
  def edit
    # 如果答卷还没有评分，允许重做。如果已经评分，则新建评估
    unless current_user.has_role? :admin
       @justice = Justice.find_by(evaluation: @evaluation.id)
      if @justice
	session[:practice_id] = @evaluation.practice_id
 	session[:tutor_id] = @evaluation.tutor_id
        session[:redo_practice] = true
        respond_to do |format|
          format.html { redirect_to new_evaluation_path, notice: '重新做题' }
	end
      end
    end
  end

  # POST /evaluations
  # POST /evaluations.json
  def create
    if current_user.has_role? :admin
      @evaluation = Evaluation.new(evaluation_params)
    else
      @practice = Practice.find(session[:practice_id])
      @evaluation = Evaluation.new(evaluation_params)
      @evaluation.tutor_id = session[:tutor_id]
      @evaluation.user_id = current_user.id
      @evaluation.practice_id = @practice.id
      @evaluation.title = @practice.title
      @evaluation.question = @practice.question
      @evaluation.answer = @practice.answer
      @evaluation.practice_score = @practice.score
    end
    respond_to do |format|
      if @evaluation.save
      if @practice.answer == @evaluation.your_answer   # 如果答对了
          @justice = Justice.create!(
            user_id: 1,
            evaluation_user_id: @evaluation.user_id,
             practice_id: @evaluation.practice_id,
	    evaluation_id:  @evaluation.id,
	    score: @practice.score,
            remark: "完全正确！",
	    title: @practice.title,
	    question: @practice.question,
	    answer: @practice.answer,
	    your_answer: @evaluation.your_answer,
	    practice_score: @practice.score
         )
      end
        format.html { redirect_to @evaluation, notice: '答案提交成功' }
        format.json { render :show, status: :created, location: @evaluation }
      else
        format.html { render :new }
        format.json { render json: @evaluation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /evaluations/1
  # PATCH/PUT /evaluations/1.json
  def update
    respond_to do |format|
      if @evaluation.update(evaluation_params)
    @practice = Practice.find(@evaluation.practice_id)
    if @practice.answer == @evaluation.your_answer
       @justice = Justice.create(
         user_id: 1,
         evaluation_user_id: @evaluation.user_id,
         practice_id: @evaluation.practice_id,
         evaluation_id: @evaluation.id,
         score: @practice.score,
         remark: "完全正确！",
         title: @practice.title,
         question: @practice.question,
         answer: @practice.answer,
         your_answer: @evaluation.your_answer,
         practice_score: @practice.score
       )
    end
        format.html { redirect_to @evaluation, notice: "答案更新成功" }
        format.json { render :show, status: :ok, location: @evaluation }
      else
        format.html { render :edit }
        format.json { render json: @evaluation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /evaluations/1
  # DELETE /evaluations/1.json
  def destroy
    @evaluation.destroy
    respond_to do |format|
      format.html { redirect_to evaluations_url, notice: '答题记录已被删除' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_evaluation
      @evaluation = Evaluation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def evaluation_params
      params.require(:evaluation).permit(:user_id, :tutor_id, :practice_id, :title, :question, :answer, :your_answer, :score, :practice_score)
    end
end
