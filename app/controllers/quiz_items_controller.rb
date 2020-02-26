class QuizItemsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_quiz_item, only: [:show, :edit, :update, :destroy]

  # GET /quiz_items
  # GET /quiz_items.json
  def index
    session[:quiz_itme_id] = nil
    if current_user.has_role? :admin
      @quiz_items = QuizItem.all
    elsif session[:quiz_id]
      @quiz = Quiz.find(session[:quiz_id])
      @quiz_items = QuizItem.where(quiz_id: @quiz.id)
    else
      redirect_back fallback_location: root_path, notice: "没有相应的测试。"
    end
  end

  # GET /quiz_items/1
  # GET /quiz_items/1.json
  def show
    if current_user.has_role? :admin
    else
      @quiz = Quiz.find(session[:quiz_id])
      @cardbox = Cardbox.find(session[:cardbox_id])
      @practice = @quiz_item.practice
    end
  end

  # GET /quiz_items/new
  def new
    @quiz_item = QuizItem.new
  end

  # GET /quiz_items/1/edit
  def edit
    redirect_back fallback_location: root_path, notice: "您不应随意更改记录。"
=begin
=end
  end

  # POST /quiz_items
  # POST /quiz_items.json
  def create
    @quiz_item = QuizItem.new(quiz_item_params)

    respond_to do |format|
      if @quiz_item.save
        format.html { redirect_to @quiz_item, notice: 'Quiz item was successfully created.' }
        format.json { render :show, status: :created, location: @quiz_item }
      else
        format.html { render :new }
        format.json { render json: @quiz_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quiz_items/1
  # PATCH/PUT /quiz_items/1.json
  def update
    redirect_back fallback_location: root_path, notice: "您不应随意更改记录。"
=begin
    respond_to do |format|
      if @quiz_item.update(quiz_item_params)
        format.html { redirect_to @quiz_item, notice: 'Quiz item was successfully updated.' }
        format.json { render :show, status: :ok, location: @quiz_item }
      else
        format.html { render :edit }
        format.json { render json: @quiz_item.errors, status: :unprocessable_entity }
      end
    end
=end
  end

  # DELETE /quiz_items/1
  # DELETE /quiz_items/1.json
  def destroy
    redirect_back fallback_location: root_path, notice: "您不应随意更改记录。"
=begin
    @quiz_item.destroy
    respond_to do |format|
      format.html { redirect_to quiz_items_url, notice: 'Quiz item was successfully destroyed.' }
      format.json { head :no_content }
    end
=end
  end

  def right
    @quiz_item = QuizItem.find(params[:quiz_item_id])
    if Time.now > @quiz_item.quiz.created_at + @quiz_item.quiz.duration
      redirect_to quiz_items_url, notice: "测试时间已过，您不能更改测试记录。"
    else
      @quiz_item.update(isright: true)
      @next_quiz_item = QuizItem.where(quiz_id: @quiz_item.quiz_id, isright: nil).sample
      if @next_quiz_item
        redirect_to quiz_item_url(@next_quiz_item)
      else
        redirect_to quiz_url(@quiz_item.quiz_id), notice: "恭喜，您已经完成了这次测试！"
    end
    end
  end

  def wrong
    @quiz_item = QuizItem.find(params[:quiz_item_id])
    if Time.now > @quiz_item.quiz.created_at + @quiz_item.quiz.duration
      redirect_to quiz_items_url, notice: "测试时间已过，您不能更改测试记录。"
    else
      @quiz_item.update(isright: false)
      @next_quiz_item = QuizItem.where(quiz_id: @quiz_item.quiz_id, isright: nil).sample
      if @next_quiz_item
        redirect_to quiz_item_url(@next_quiz_item)
      else
        redirect_to quiz_url(@quiz_item.quiz_id), notice: "恭喜，您已经完成了这次测试！"
      end
    end 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quiz_item
      @quiz_item = QuizItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quiz_item_params
      params.require(:quiz_item).permit(:user_id, :quiz_id, :practice_id, :isright, :deleted_at)
    end
end
