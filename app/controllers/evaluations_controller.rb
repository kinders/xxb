class EvaluationsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_evaluation, only: [:show, :edit, :update, :destroy]

  # GET /evaluations
  # GET /evaluations.json
  def index
    session[:evaluation_id] = nil
    if current_user.has_role? :admin
      @evaluations = Evaluation.all
    else
      @lesson = Lesson.find(session[:lesson_id]) if session[:lesson_id]
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
    else   # 普通用户
      @lesson = Lesson.find(session[:lesson_id]) if session[:lesson_id]
      @tutor = Tutor.find(session[:tutor_id]) if session[:tutor_id]
      if session[:redo_practice]      ## 如果没有指定练习，但存在重做标记（这是由edit方法自动重定向过来的）。
        @practice = Practice.find(session[:practice_id])
        session[:practice_id] = @practice.id
        @evaluation = Evaluation.new { |e|
          e.title = @practice.title
          e.material = @practice.material
          e.question = @practice.question
          e.practice_score = @practice.score
        }
        session[:redo_practice] = nil
        flash[:notice] = "旧题新做"
      elsif session[:papertest_id] ## 如果是考试环境
        @papertest = Papertest.find(session[:papertest_id])
        if Time.now < @papertest.end_at
          @practice = Practice.find(params[:practice_id])
          session[:practice_id] = @practice.id
          @evaluation = Evaluation.new { |e|
            e.title = @practice.title
            e.material = @practice.material
            e.question = @practice.question
            e.practice_score = params[:practice_score]
          }
        else
          session[:papertest_id] = nil
          redirect_to paper_url(@papertest.paper_id), notice: "考试已结束！"
          return
        end
      elsif params[:practice_id] ## 如果指定了哪道习题
        @practice = Practice.find(params[:practice_id])
        session[:practice_id] = @practice.id
        @evaluation = Evaluation.new { |e|
          e.title = @practice.title
          e.material = @practice.material
          e.question = @practice.question
          e.practice_score = @practice.score
        }
        if Evaluation.find_by(practice_id: @practice.id, user_id: current_user.id)
          flash[:notice] = "旧题新做"
        end
      else ## 正常情况下
        ### 随机取出未完全答对的练习题
        @use_practices = []
        #### 判断是课文练习还是辅导练习，决定题目集合
        if @tutor
          @practices = @tutor.exercises.map{|exercise|Practice.find(exercise.practice_id)}
        else
          @practices = Practice.where(lesson_id: @lesson.id)
        end
        #### 抽出没有做过的题目
        @practices.each { | p |
          unless Evaluation.find_by(practice_id: p.id, user_id: current_user.id)
             @use_practices << p
          end
        }
        @practice = @use_practices.sample
        ### 根据取题情况进行页面的渲染
        if @practice
          session[:practice_id] = @practice.id
          @evaluation = Evaluation.new { |e|
            e.title = @practice.title
            e.material = @practice.material
            e.question = @practice.question
            e.practice_score = @practice.score
          }
        else              ### 如果没有取出题目
          respond_to do |format|
            format.html { redirect_back fallback_location: root_path, notice: "暂时没有可用的练习了。"}
	        end
        end
      end
    end
  end

  # GET /evaluations/1/edit
  def edit
    if current_user.has_role? :admin
    else
      @practice = Practice.find(@evaluation.practice_id)
      # 如果已经评分，则新建评估
      @justice = Justice.find_by(evaluation: @evaluation.id)
      if @justice
	      session[:practice_id] = @evaluation.practice_id
 	      session[:lesson_id] = @evaluation.lesson_id
        session[:redo_practice] = true
        respond_to do |format|
          format.html { redirect_to new_evaluation_path, notice: '重新做题' }
	      end
      end
      # 如果答卷还没有评分，允许重做。
      # 如果在测试环境中，则检查是否超时
      if session[:papertest_id]
        @papertest = Papertest.find(session[:papertest_id])
        if Time.now > @papertest.end_at
          session[:papertest_id] = nil
          redirect_to paper_url(@papertest.paper_id), notice: "考试已结束！"
          return
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
      @evaluation.lesson_id = session[:lesson_id]
      @evaluation.user_id = current_user.id
      @evaluation.practice_id = @practice.id
      @evaluation.title = @practice.title
      @evaluation.material = @practice.material
      @evaluation.question = @practice.question
      @evaluation.answer = @practice.answer
      @evaluation.practice_score ||= @practice.score
      if session[:papertest_id]
        @papertest = Papertest.find(session[:papertest_id])
        if Time.now < @papertest.end_at
          @evaluation.end_at = @papertest.end_at
          @evaluation.papertest_id = @papertest.id
        else
          session[:papertest_id] = nil
          redirect_to paper_url(@papertest.paper_id), notice: "考试已结束！"
          return
        end
      end
    end
    respond_to do |format|
      if @evaluation.save
        if @practice.answer.gsub(/(<(\w|\/)+[^>]*>|\s)/, "") == @evaluation.your_answer.gsub(/(<(\w|\/)+[^>]*>|\s)/, "")   # 如果答对了
          @justice = Justice.create!(
            user_id: 1,
            evaluation_user_id: @evaluation.user_id,
            practice_id: @evaluation.practice_id,
	          evaluation_id:  @evaluation.id,
	          score: @evaluation.practice_score,  # 得到满分
	          p_score: @evaluation.practice_score,
            remark: "完全正确！",
          )
          @evaluation.update(score: @evaluation.practice_score)
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
          @justice = Justice.create!(
            user_id: 1,
            evaluation_user_id: @evaluation.user_id,
            practice_id: @evaluation.practice_id,
	          evaluation_id:  @evaluation.id,
	          score: @evaluation.practice_score,  # 得到满分
	          p_score: @evaluation.practice_score,
            remark: "完全正确！",
          )
          @evaluation.update(score: @evaluation.practice_score)
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

  def delete_picture_ya
    @evaluation = Evaluation.find(session[:evaluation_id])
    @evaluation.picture_ya = nil
    @evaluation.save
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, notice: "答题图片已经被删除" }
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
      params.require(:evaluation).permit(:user_id, :lesson_id, :practice_id, :title, :material, :question, :answer, :your_answer, :score, :practice_score, :picture_ya, :end_at, :papertest)
    end
end
