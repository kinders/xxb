class QuizzesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_quiz, only: [:show, :edit, :update, :destroy]

  # GET /quizzes
  # GET /quizzes.json
  def index
    @quizzes = Quiz.all
    if current_user.has_role? :admin
      @quizzes = QuizItem.all
    elsif session[:cardbox_id]
      @cardbox = Cardbox.find(session[:cardbox_id])
      @quizzes = Quiz.where(cardbox_id: @cardbox.id, user_id: current_user.id).order(id: :desc)
    else
      redirect_to cardboxes_path, notice: "没有相应的测试。请指定一个卡片盒。"
    end
  end

  # GET /quizzes/1
  # GET /quizzes/1.json
  def show
    if current_user.has_role? :admin
    else
      session[:quiz_id] = @quiz.id
      redirect_to quiz_items_url
    end
  end

  # GET /quizzes/new
  def new
    if current_user.has_role? :admin
      @quiz = Quiz.new
    elsif session[:cardbox_id]
      @cardbox = Cardbox.find(session[:cardbox_id])
      @quiz = Quiz.new { |quiz|
        quiz.title = @cardbox.name + "_" + Time.now.strftime("%F %T")
        quiz.number = @cardbox.cards.count / 3
        quiz.repetition = 2
        quiz.duration = quiz.number * 10
      }
    else
      redirect_to quizzes_path, notice: "不能测试。请先指定卡片盒。"
    end
  end

  # GET /quizzes/1/edit
  def edit
    redirect_to :back, notice: "不能修改测试数据。"
=begin
=end
  end

  # POST /quizzes
  # POST /quizzes.json
  def create
    @quiz = Quiz.new(quiz_params)
    @quiz.user_id = current_user.id
    @quiz.cardbox_id = session[:cardbox_id]
    if @quiz.save
      @practices = @quiz.cardbox.cards.collect{|c| c.practice_id}.sample(@quiz.number)
      @quiz.number.times do 
        @quiz.repetition.times do
          quiz_item = QuizItem.new { |quiz_item|
            quiz_item.user_id = current_user.id
            quiz_item.quiz_id = @quiz.id
            quiz_item.practice_id = @practices.first
          }
          quiz_item.save
        end
        @practices.shift
      end
      session[:quiz_id] = @quiz.id
      respond_to do |format|
        format.html { redirect_to quiz_item_url(@quiz.quiz_items.first.id), notice: '测试开始，请您务必集中精力！' }
        format.json { render :show, status: :created, location: @quiz }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quizzes/1
  # PATCH/PUT /quizzes/1.json
  def update
    redirect_to :back, notice: "不能修改测试数据。"
=begin
    respond_to do |format|
      if @quiz.update(quiz_params)
        format.html { redirect_to @quiz, notice: 'Quiz was successfully updated.' }
        format.json { render :show, status: :ok, location: @quiz }
      else
        format.html { render :edit }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
=end
  end

  # DELETE /quizzes/1
  # DELETE /quizzes/1.json
  def destroy
    @quiz.destroy
    respond_to do |format|
      format.html { redirect_to quizzes_url, notice: 'Quiz was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quiz
      @quiz = Quiz.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quiz_params
      params.require(:quiz).permit(:user_id, :cardbox_id, :title, :number, :repetition, :duration, :deleted_at)
    end
end
