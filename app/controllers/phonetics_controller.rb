class PhoneticsController < ApplicationController
  skip_before_action :check_user_active_time
  skip_authorization_check
  before_action :set_phonetic, only: [:show, :edit, :update, :destroy]

  # GET /phonetics
  # GET /phonetics.json
  def index
    @phonetics = Phonetic.all.order("id").page(params[:page]).per('100')
  end

  # GET /phonetics/1
  # GET /phonetics/1.json
  def show
    @words = @phonetic.words.order(:id)
    # 生成上一个和下一个音节
    all_phonetics_id = Phonetic.all.order("id").pluck("id")
    current_phonetic_id = all_phonetics_id.index(@phonetic.id)
    if current_phonetic_id == 0
      @previous_phonetic = nil
    else
      @previous_phonetic = all_phonetics_id[current_phonetic_id - 1]
    end
    if current_phonetic_id == all_phonetics_id.size
      @next_phonetic == nil
    else
      @next_phonetic = all_phonetics_id[current_phonetic_id + 1]
    end
  end

  # GET /phonetics/new
  def new
    @phonetic = Phonetic.new
  end

  # GET /phonetics/1/edit
  def edit
  end

  # POST /phonetics
  # POST /phonetics.json
  def create
    @phonetic = Phonetic.new(phonetic_params)

    respond_to do |format|
      if @phonetic.save
        format.html { redirect_to @phonetic, notice: 'Phonetic was successfully created.' }
        format.json { render :show, status: :created, location: @phonetic }
      else
        format.html { render :new }
        format.json { render json: @phonetic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /phonetics/1
  # PATCH/PUT /phonetics/1.json
  def update
    respond_to do |format|
      if @phonetic.update(phonetic_params)
        format.html { redirect_to @phonetic, notice: 'Phonetic was successfully updated.' }
        format.json { render :show, status: :ok, location: @phonetic }
      else
        format.html { render :edit }
        format.json { render json: @phonetic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /phonetics/1
  # DELETE /phonetics/1.json
  def destroy
    @phonetic.destroy
    respond_to do |format|
      format.html { redirect_to phonetics_url, notice: 'Phonetic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /phonetic/create_phonetic_for_word
  def create_phonetic_for_word
    @word = Word.find(session[:word_id])
    @phonetic = Phonetic.find_by(content: params[:content], label: params[:label])
    if @phonetic
      if @word.phonetics.exists?(@phonetic)
        redirect_back fallback_location: root_path, notice: "这个拼音已经存在，无需重复添加。"
        return
      else
        word_p_count = @word.phonetics_count + 1
        @word.phonetic_notations.create(word_id: @word.id, phonetic_id: @phonetic.id)
        @word.update(phonetics_count: word_p_count)
      end
    else
      @word.phonetics.create(content: params[:content], label: params[:label])
      word_p_count = @word.phonetics_count + 1
      @word.update(phonetics_count: word_p_count)
    end
    redirect_back fallback_location: root_path, notice: "成功添加拼音。"
  end

  def chinese_yinxu
  end

  def chinese_rhyme
  end

  def list_rhyme_words
    @rhymes = params[:rhyme].split(", ")
    phonetic_ids = Phonetic.where(rhyme: @rhymes).pluck(:id)
    word_ids = PhoneticNotation.where(phonetic_id: phonetic_ids).pluck(:word_id)
    @words = Word.where(id: word_ids).pluck(:name).join("，")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_phonetic
      @phonetic = Phonetic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def phonetic_params
      params.require(:phonetic).permit(:content, :label, :rhyme, :deleted_at)
    end
end
