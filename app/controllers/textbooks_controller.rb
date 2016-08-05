class TextbooksController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_textbook, only: [:show, :edit, :update, :destroy]
  before_action :be_a_master, except: [:index, :show]

  # GET /textbooks
  # GET /textbooks.json
  def index
    @textbooks = Textbook.all.order(:serial)
    session[:textbook_id] = nil
  end

  # GET /textbooks/1
  # GET /textbooks/1.json
  def show
    history = History.create { |h| 
      h.user_id = current_user.id
      h.modelname = "textbook"
      h.entryid = @textbook.id
    }
    session[:textbook_id] = @textbook.id
    session[:lesson_id] = nil
    unless current_user.has_role? :admin
      respond_to do |format|
        format.html { redirect_to catalogs_path }
      end
    end
  end

  # GET /textbooks/new
  def new
    @textbook = Textbook.new
  end

  # GET /textbooks/1/edit
  def edit
  end

  # POST /textbooks
  # POST /textbooks.json
  def create
    @textbook = Textbook.new(textbook_params)
    unless current_user.has_role? :admin
      @textbook.user_id = current_user.id
    end
    respond_to do |format|
      if @textbook.save
        format.html { redirect_to @textbook, notice: "教科书已被成功创建" }
        format.json { render :show, status: :created, location: @textbook }
      else
        format.html { render :new }
        format.json { render json: @textbook.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /textbooks/1
  # PATCH/PUT /textbooks/1.json
  def update
    unless current_user.has_role? :admin
      @textbook.user_id = current_user.id
    end
    respond_to do |format|
      if @textbook.update(textbook_params)
        format.html { redirect_to @textbook, notice: "教科书已被成功更新" }
        format.json { render :show, status: :ok, location: @textbook }
      else
        format.html { render :edit }
        format.json { render json: @textbook.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /textbooks/1
  # DELETE /textbooks/1.json
  def destroy
    @textbook.destroy
    respond_to do |format|
      format.html { redirect_to textbooks_url, notice: "教科书已被成功删除" }
      format.json { head :no_content }
    end
  end

  # 一本书的用字报告。
  ## 包含两个部分：按字排序，按频排序。
  ### 按字排序
  def single_words
    @textbook = Textbook.find(session[:textbook_id])
    lesson_ids = @textbook.lessons.pluck(:id)
    all_words = WordParser.where(lesson_id: lesson_ids).pluck("word_id").uniq
    @word_parsers_in_group = Word.where(id: all_words, length: 1).page(params[:page]).per(100)
  end
  ### 按字频率排序
  def single_words_in_freq
    @textbook = Textbook.find(session[:textbook_id])
    lesson_ids = @textbook.lessons.pluck(:id)
    all_words = WordParser.includes(:word).where(lesson_id: lesson_ids, words: {length: 1}).pluck("word_id")
    word_parsers_in_group = all_words.group_by {|word| [word, all_words.count(word)]}.keys.sort {|a, b| a[1]<=>b[1]}

    @word_parsers_in_group = Kaminari.paginate_array(word_parsers_in_group).page(params[:page]).per(100)
  end

  # 一本书的用词报告。
  ## 包含两个部分：按字排序，按频排序。
  ### 按字排序
  def meanful_words
    @textbook = Textbook.find(session[:textbook_id])
    lesson_ids = @textbook.lessons.pluck(:id)
    all_words = WordParser.where(lesson_id: lesson_ids).pluck("word_id").uniq
    @word_parsers_in_group = Word.where(id: all_words, length: [2..100], is_meanful: true).order(:name).page(params[:page]).per(100)
  end
  ### 按频排序
  def meanful_words_in_freq
    @textbook = Textbook.find(session[:textbook_id])
    lesson_ids = @textbook.lessons.pluck(:id)
    all_words = WordParser.includes(:word).where(lesson_id: lesson_ids, words: {length: 2..100, is_meanful: true}).pluck("word_id")
    word_parsers_in_group = all_words.group_by {|word| [word, all_words.count(word)]}.keys.sort {|a, b| a[1]<=>b[1]}

    @word_parsers_in_group = Kaminari.paginate_array(word_parsers_in_group).page(params[:page]).per(100)
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_textbook
      @textbook = Textbook.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def textbook_params
      params.require(:textbook).permit(:title, :description, :serial, :user_id)
    end

    def be_a_master
      unless Master.find_by(user_id: current_user.id)
        redirect_to :back, notice: "对不起，您暂时还没有老师的身份来进行操作。"
      end
    end
end
