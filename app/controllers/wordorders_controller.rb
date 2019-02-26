class WordordersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_wordorder, only: [:show, :edit, :update, :destroy]

  # GET /wordorders
  # GET /wordorders.json
  def index
    if current_user.has_role? :admin
      @wordorders = Wordorder.all
    elsif session[:wordmap_id]
      @wordmap = Wordmap.find(session[:wordmap_id])
      @wordorders = Wordorder.where(user_id: current_user.id, wordmap_id: @wordmap.id).order(:serial)
      words = @wordmap.words.pluck(:id, :name)
      @word_ids = words.map{|i| i[0]}
      @word_names = words.map{|i| i[1]}
    else
      redirect_to roadmaps_url, notice: "请先指定文路和词序表。"
    end
  end

  # GET /wordorders/1
  # GET /wordorders/1.json
  def show
    # 生成上一个和下一个词语
    all_wordorders_id = Wordorder.where(id: (@wordorder.id - 50)..(@wordorder.id + 50)).pluck("id")
    current_wordorder_id = all_wordorders_id.index(@wordorder.id)
    if current_wordorder_id == 0
      @previous_wordorder = nil
    else
      @previous_wordorder = all_wordorders_id[current_wordorder_id - 1]
    end
    if current_wordorder_id == all_wordorders_id.size
      @next_wordorder == nil
    else
      @next_wordorder = all_wordorders_id[current_wordorder_id + 1]
    end
  end

# =begin
  # GET /wordorders/new
  def new
    @wordorder = Wordorder.new
  end

  # GET /wordorders/1/edit
  def edit
  end

  # POST /wordorders
  # POST /wordorders.json
  def create
    @wordorder = Wordorder.new(wordorder_params)
    @wordorder.user_id = current_user.id
    if session[:wordmap_id]
      @wordorder.wordmap_id = session[:wordmap_id]
    else
      redirect_to :back, notice: "找不到词序表，无法添加词序"
      return
    end

    respond_to do |format|
      if @wordorder.save
        format.html { redirect_to @wordorder, notice: 'Wordorder was successfully created.' }
        format.json { render :show, status: :created, location: @wordorder }
      else
        format.html { render :new }
        format.json { render json: @wordorder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wordorders/1
  # PATCH/PUT /wordorders/1.json
  def update
    respond_to do |format|
      if @wordorder.update(wordorder_params)
        format.html { redirect_to @wordorder, notice: 'Wordorder was successfully updated.' }
        format.json { render :show, status: :ok, location: @wordorder }
      else
        format.html { render :edit }
        format.json { render json: @wordorder.errors, status: :unprocessable_entity }
      end
    end
  end
# =end

  # DELETE /wordorders/1
  # DELETE /wordorders/1.json
  def destroy
    @next = Wordorder.find_by(id: @wordorder.id + 1)
    @wordorder.destroy
    respond_to do |format|
      format.html { redirect_to wordorder_url(@next), notice: 'Wordorder was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /wordorder_update_serial
  def update_serial
    @wordmap = Wordmap.find(params[:wordmap_id])
    @wordorders = @wordmap.wordorders.order(:serial)
    # 如果长度相等，则不用更改，否则需要更改。
    if @wordorders.size != @wordorders.last.serial
      @wordorders.each_with_index do |wordorder, index|
        wordorder.update(serial: index + 1) unless wordorder.serial == index + 1
      end
    end
    redirect_to :back, notice: '序列更新完毕'
  end

  def load_wordorders
    unless session[:wordmap_id]
      redirect_to :back, notice: '请先指定一个词序表'
      return
    end
    @wordmap = Wordmap.find(session[:wordmap_id])
    last_word = @wordmap.wordorders.order(:serial).last
    if last_word
      last_serial = last_word.serial 
    else
      last_serial = 1
    end
    wordorder_p = []
    words = []
    name =  "wordorders" + '_' + current_user.id.to_s + '_' + Time.now.to_s
    directory = "public/data_import"
    path = File.join(directory, name)
    File.open(path, "wb") { |f| f.write(params[:csv_file].read) }
    data = SmarterCSV.process(path) do |allline|
      allline.each do |one_line|
        words << one_line[:word]
      end
    end
    logger.error("words: " + words.join(","))
    words.each_slice(500) do |ws|
      query_words = Word.where(name: ws)
      query_word_names = query_words.map{|i|i.name}
      logger.error("query_word_names: " + query_word_names.join(","))
      unfind_words = ws - query_word_names
      if unfind_words.blank?
        logger.error("last_serial: " + last_serial.to_s)
        query_word_ids = query_words.map{|i|i.id}
        logger.error("query_word_ids: " + query_word_ids.join(","))
        query_word_index = []
        query_word_names.each do |i|
          query_word_index << words.index(i)
        end
        logger.error("query_word_index: " + query_word_index.join(","))
        1.upto(query_word_ids.count) do |i|
          j = i - 1
          logger.error("j: " + j.to_s)
          k = query_word_index[j] + last_serial
          logger.error("k: " + k.to_s)
          wordorder_p << { word_id: query_word_ids[j], user_id: current_user.id, wordmap_id: @wordmap.id, serial: k }
        end
        Wordorder.create(wordorder_p)
        last_serial = last_serial + 500
        wordorder_p = []
      else
        logger.error("找不到部分词语" + unfind_words.join(','))
        unfind_words.each do |u|
          Word.create(name: u, length: u.length, is_meanful: true)
        end
        redo
      end
    end
    respond_to do |format|
      format.html { redirect_to :back, notice: '成功导入所有词序！' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wordorder
      @wordorder = Wordorder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wordorder_params
      params.require(:wordorder).permit(:user_id, :wordmap_id, :word_id, :serial, :deleted_at)
    end
end
