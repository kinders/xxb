class MeaningsController < ApplicationController
  skip_before_action :check_user_active_time
  skip_authorization_check
  before_action :set_meaning, only: [:show, :edit, :update, :destroy]

  # GET /meanings
  # GET /meanings.json
  def index
    @meanings = Meaning.all.page(params[:page]).per('10')
  end

  # GET /meanings/1
  # GET /meanings/1.json
  def show
    @word = Word.find(session[:word_id])
  end

  # GET /meanings/new
  def new
    @meaning = Meaning.new
  end

  # GET /meanings/1/edit
  def edit
  end

  # POST /meanings
  # POST /meanings.json
  def create
    @meaning = Meaning.new(meaning_params)

    respond_to do |format|
      if @meaning.save
        word = Word.find(@meaning.word_id)
        word_m_count = word.meanings_count + 1
        word.update(meanings_count: word_m_count)
        format.html { redirect_to word, notice: '成功新增一种词义。' }
        # format.html { redirect_to @meaning, notice: 'Meaning was successfully created.' }
        format.json { render :show, status: :created, location: @meaning }
      else
        format.html { render :new }
        format.json { render json: @meaning.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /meanings/1
  # PATCH/PUT /meanings/1.json
  def update
    respond_to do |format|
      if @meaning.update(meaning_params)
        format.html { redirect_to word_path(@meaning.word_id), notice: '成功更新词义。' }
        # format.html { redirect_to @meaning, notice: '成功更新词义。' }
        format.json { render :show, status: :ok, location: @meaning }
      else
        format.html { render :edit }
        format.json { render json: @meaning.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meanings/1
  # DELETE /meanings/1.json
  def destroy
    word = Word.find(@meaning.word_id)
    word_m_count = word.meanings_count - 1
    word.update(meanings_count: word_m_count)
    @meaning.destroy
    respond_to do |format|
      format.html { redirect_to meanings_url, notice: 'Meaning was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search_meanings
    @search = params[:pattern]
    @words = Word.where("name LIKE ?", "%" + params[:pattern] +"%" ).where(is_meanful: true)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meaning
      @meaning = Meaning.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def meaning_params
      params.require(:meaning).permit(:content, :word_id, :deleted_at)
    end
end
