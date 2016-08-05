class SentencesController < ApplicationController
  skip_before_action :check_user_active_time
  skip_authorization_check
  before_action :set_sentence, only: [:show, :edit, :update, :destroy]

  # GET /sentences
  # GET /sentences.json
  def index
    if current_user.has_role? :admin
      @sentences = Sentence.all
    else
      session[:sentence_id] = nil
      @lesson = Lesson.find_by(id: session[:lesson_id])
      @sentences = Sentence.where(lesson_id: session[:lesson_id]).order("id").page(params[:page]).per(10)
      unless @lesson
        redirect_to root_path, notice: "操作出错：无法找到指定的课程。"
      end
    end

  end

  # GET /sentences/1
  # GET /sentences/1.json
  def show
    @word_parsers = @sentence.word_parsers.order(:id)
    # 生成上一个和下一个词语
    if session[:lesson_id]
      @lesson = Lesson.find(session[:lesson_id])
      all_sentences_id = Sentence.where(lesson_id: @lesson.id).pluck("id").sort
    else
      all_sentences_id = Sentence.all.pluck("id").sort
    end
    current_sentence_id = all_sentences_id.index(@sentence.id)
    if current_sentence_id == 0
      @previous_sentence = nil
    else
      @previous_sentence = all_sentences_id[current_sentence_id - 1]
    end
    if current_sentence_id == all_sentences_id.size
      @next_sentence == nil
    else
      @next_sentence = all_sentences_id[current_sentence_id + 1]
    end
  end

  # GET /sentences/new
  def new
    @sentence = Sentence.new
  end

  # GET /sentences/1/edit
  def edit
  end

  # POST /sentences
  # POST /sentences.json
  def create
    @sentence = Sentence.new(sentence_params)

    respond_to do |format|
      if @sentence.save
        format.html { redirect_to @sentence, notice: 'Sentence was successfully created.' }
        format.json { render :show, status: :created, location: @sentence }
      else
        format.html { render :new }
        format.json { render json: @sentence.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sentences/1
  # PATCH/PUT /sentences/1.json
  def update
    respond_to do |format|
      if @sentence.update(sentence_params)
        format.html { redirect_to @sentence, notice: 'Sentence was successfully updated.' }
        format.json { render :show, status: :ok, location: @sentence }
      else
        format.html { render :edit }
        format.json { render json: @sentence.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sentences/1
  # DELETE /sentences/1.json
  def destroy
    @sentence.destroy
    respond_to do |format|
      format.html { redirect_to sentences_url, notice: 'Sentence was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sentence
      @sentence = Sentence.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sentence_params
      params.require(:sentence).permit(:lesson_id, :name, :deleted_at)
    end
end
