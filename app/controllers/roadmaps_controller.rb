class RoadmapsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_roadmap, only: [:show, :edit, :update, :destroy]

  # GET /roadmaps
  # GET /roadmaps.json
  def index
    session[:roadmap_id] = nil
    if current_user.has_role? :admin
      @roadmaps = Roadmap.all.order("id")
    else
      @roadmaps = Roadmap.where(user_id: current_user.id).order("id")
    end
  end

  # GET /roadmaps/1
  # GET /roadmaps/1.json
  def show
    session[:roadmap_id] = @roadmap.id
    unless current_user.has_role? :admin
      respond_to do |format|
        format.html { redirect_to paces_path }
      end
    end
  end

  # GET /roadmaps/new
  def new
    @roadmap = Roadmap.new
  end

  # GET /roadmaps/1/edit
  def edit
  end

  # POST /roadmaps
  # POST /roadmaps.json
  def create
    @roadmap = Roadmap.new(roadmap_params)
    @roadmap.user_id = current_user.id

    respond_to do |format|
      if @roadmap.save
        format.html { redirect_to @roadmap, notice: 'Roadmap was successfully created.' }
        format.json { render :show, status: :created, location: @roadmap }
      else
        format.html { render :new }
        format.json { render json: @roadmap.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roadmaps/1
  # PATCH/PUT /roadmaps/1.json
  def update
    respond_to do |format|
      if @roadmap.update(roadmap_params)
        format.html { redirect_to @roadmap, notice: 'Roadmap was successfully updated.' }
        format.json { render :show, status: :ok, location: @roadmap }
      else
        format.html { render :edit }
        format.json { render json: @roadmap.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roadmaps/1
  # DELETE /roadmaps/1.json
  def destroy
    @roadmap.destroy
    respond_to do |format|
      format.html { redirect_to roadmaps_url, notice: 'Roadmap was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # 文路的用字报告。
  ## 包含两个部分：按字排序，按频排序。
  ### 按字排序
  def single_words
    @roadmap = Roadmap.find(session[:roadmap_id])
    lesson_ids = @roadmap.lessons.pluck(:id)
    all_words = WordParser.where(lesson_id: lesson_ids).pluck("word_id").uniq
    @word_parsers_in_group = Word.where(id: all_words, length: 1).page(params[:page]).per(100)
  end
  ### 按字频率排序
  def single_words_in_freq
    @roadmap = Roadmap.find(session[:roadmap_id])
    lesson_ids = @roadmap.lessons.pluck(:id)
    all_words = WordParser.includes(:word).where(lesson_id: lesson_ids, words: {length: 1}).pluck("word_id")
    word_parsers_in_group = all_words.group_by {|word| [word, all_words.count(word)]}.keys.sort {|a, b| a[1]<=>b[1]}

    @word_parsers_in_group = Kaminari.paginate_array(word_parsers_in_group).page(params[:page]).per(100)
  end

  # 文路的用词报告。
  ## 包含两个部分：按字排序，按频排序。
  ### 按字排序
  def meanful_words
    @roadmap = Roadmap.find(session[:roadmap_id])
    lesson_ids = @roadmap.lessons.pluck(:id)
    all_words = WordParser.where(lesson_id: lesson_ids).pluck("word_id").uniq
    @word_parsers_in_group = Word.where(id: all_words, length: [2..100], is_meanful: true).order(:name).page(params[:page]).per(100)
  end
  ### 按频排序
  def meanful_words_in_freq
    @roadmap = Roadmap.find(session[:roadmap_id])
    lesson_ids = @roadmap.lessons.pluck(:id)
    all_words = WordParser.includes(:word).where(lesson_id: lesson_ids, words: {length: 2..100, is_meanful: true}).pluck("word_id")
    word_parsers_in_group = all_words.group_by {|word| [word, all_words.count(word)]}.keys.sort {|a, b| a[1]<=>b[1]}

    @word_parsers_in_group = Kaminari.paginate_array(word_parsers_in_group).page(params[:page]).per(100)
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_roadmap
      @roadmap = Roadmap.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def roadmap_params
      params.require(:roadmap).permit(:name, :description, :user_id, :deleted_at)
    end
end
