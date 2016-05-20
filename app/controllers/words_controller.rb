class WordsController < ApplicationController
  skip_before_action :check_user_active_time
  skip_authorization_check
  before_action :set_word, only: [:show, :edit, :update, :destroy]

  # GET /words
  # GET /words.json
  def index
    if current_user.has_role? :admin 
      @words = Word.all.page params[:page]

    else
      redirect_to root_path, notice: "您没有权限查看字典，请进行其他操作。"
    end
  end

  # GET /words/1
  # GET /words/1.json
  def show
  end

  # GET /words/new
  # def new
    # @word = Word.new
  # end

  # GET /words/1/edit
  # def edit
  # end

  # POST /words
  # POST /words.json
  # def create
    # @word = Word.new(word_params)

    # respond_to do |format|
      # if @word.save
        # format.html { redirect_to @word, notice: 'Word was successfully created.' }
        # format.json { render :show, status: :created, location: @word }
      # else
        # format.html { render :new }
        # format.json { render json: @word.errors, status: :unprocessable_entity }
      # end
    # end
  # end

  # PATCH/PUT /words/1
  # PATCH/PUT /words/1.json
  # def update
    # respond_to do |format|
      # if @word.update(word_params)
        # format.html { redirect_to @word, notice: 'Word was successfully updated.' }
        # format.json { render :show, status: :ok, location: @word }
      # else
        # format.html { render :edit }
        # format.json { render json: @word.errors, status: :unprocessable_entity }
      # end
    # end
  # end

  # DELETE /words/1
  # DELETE /words/1.json
  # def destroy
    # @word.destroy
    # respond_to do |format|
      # format.html { redirect_to words_url, notice: 'Word was successfully destroyed.' }
      # format.json { head :no_content }
    # end
  # end

  # GET /words/1/change_meanful
  def change_meanful
    @word = Word.find(params[:word_id])
    if @word.is_meanful
      @word.update(is_meanful: nil)
      status = "无意义词汇"
    else
      @word.update(is_meanful: true)
      status = "有意义词汇"
    end
    redirect_to :back, notice: "“#{@word.name}”已经被标记为#{status}。"
  end

  # GET /words/choose_dictionary
  def choose_dictionary
    unless current_user.has_role? :admin 
      redirect_to root_path, notice: "您没有权限查看字典，请进行其他操作。"
    end
  end

  # POST /words/load_dictionary
  def load_dictionary
    require 'digest/md5'
    begin
      name =  current_user.id.to_s + '_' + Time.now.to_s
      directory = "public/data_import"
      path = File.join(directory, name)
      File.open(path, "wb") { |f| f.write(params[:csv_file].read) }
      data = SmarterCSV.process(path) do |allline|
        allline.each do |one_line|
          line = one_line[:word]
          ### 计算字符串的md值作为索引
          word_md5 = Digest::MD5.hexdigest(line).bytes.map{|b|b=b-38}.join
          ### 下面计算单位的长度，有中文则按字计算，非中文按空格计算
          if line =~ /[\u4e00-\u9fa5]/
            words_length = line.size
          else
            words_length = line.split(" ").size
          end
          #### 查找单词，找不到时创建word记录
          word = Word.find_by(md1: word_md5[0..7], md2: word_md5[8..15], md3: word_md5[16..23], md4: word_md5[24..31], md5: word_md5[32..39], md6: word_md5[40..47], md7: word_md5[48..55], md8: word_md5[56..63])
          unless word
            @word = Word.create(name: line, length: words_length, is_meanful: true, md1: word_md5[0..7], md2: word_md5[8..15], md3: word_md5[16..23], md4: word_md5[24..31], md5: word_md5[32..39], md6: word_md5[40..47], md7: word_md5[48..55], md8: word_md5[56..63])
          end
        end
      end
      respond_to do |format|
        format.html { redirect_to :back, notice: '成功导入所有单词！' }
        format.json { head :no_content }
      end
    rescue Exception => e 
      # File.delete(path)
      respond_to do |format|
        format.html { redirect_to :back, notice: "导入单词失败，请修改CSV文件后重新尝试！错误提示：#{e}" }
        format.json { head :no_content }
      end
    end
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word
      @word = Word.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def word_params
      params.require(:word).permit(:name, :length, :deleted_at, :is_meanful)
    end
end
