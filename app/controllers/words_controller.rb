class WordsController < ApplicationController
  skip_before_action :check_user_active_time
  skip_authorization_check
  before_action :set_word, only: [:show, :edit, :update, :destroy]

  # GET /words
  # GET /words.json
  def index
    # if current_user.has_role? :admin 
      @words = Word.all.page(params[:page]).per(10)
    # else
      # redirect_to root_path, notice: "您没有权限查看字典，请进行其他操作。"
    # end
  end

  # GET /words/1
  # GET /words/1.json
  def show
    session[:word_id] = @word.id
    @words_has_word = Word.where(is_meanful: true).where("name LIKE ?", "%" + @word.name + "%" ).order(:length)
    @lessons_has_word = WordParser.where(word_id: @word.id).pluck(:lesson_id).uniq
    # 生成上一个和下一个词语
    all_words_id = Word.all.pluck("id")
    current_word_id = all_words_id.index(@word.id)
    if current_word_id == 0
      @previous_word = nil
    else
      @previous_word = all_words_id[current_word_id - 1]
    end
    if current_word_id == all_words_id.size
      @next_word == nil
    else
      @next_word = all_words_id[current_word_id + 1]
    end
  end

  # GET /words/new
  def new
    redirect_to :back, notice: "您没有权限新建字典，请进行其他操作。"
    # @word = Word.new
  end

  # GET /words/1/edit
  def edit
    # redirect_to :back, notice: "您没有权限新建字典，请进行其他操作。"
  end

  # POST /words
  # POST /words.json
  def create
    require 'digest/md5'
    @word = Word.new(word_params)
    word_md = Digest::MD5.hexdigest(@word.name).bytes.map{|b|b=b-38}.join

    word = Word.find_by(md1: word_md[0..7], md2: word_md[8..15], md3: word_md[16..23], md4: word_md[24..31], md5: word_md[32..39], md6: word_md[40..47], md7: word_md[48..55], md8: word_md[56..63])
    if word
      redirect_to :back, notice: "词语已经存在，无需新建。"
      return
    else
      if @word.name =~ /[\u4e00-\u9fa5]/
        words_length = @word.name.size
      else
        words_length = @word.name.split(" ").size
      end
      @word.length = words_length
      @word.is_meanful = true
      @word.md1 = word_md[0..7]
      @word.md2 = word_md[8..15]
      @word.md3 = word_md[16..23]
      @word.md4 = word_md[24..31]
      @word.md5 = word_md[32..39]
      @word.md6 = word_md[40..47]
      @word.md7 = word_md[48..55]
      @word.md8 = word_md[56..63]
  
      respond_to do |format|
        if @word.save
          format.html { redirect_to @word, notice: 'Word was successfully created.' }
          format.json { render :show, status: :created, location: @word }
        else
          format.html { render :new }
          format.json { render json: @word.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /words/1
  # PATCH/PUT /words/1.json
  def update
    require 'digest/md5'
    respond_to do |format|
      if @word.update(word_params)
        word_md = Digest::MD5.hexdigest(@word.name).bytes.map{|b|b=b-38}.join
        if @word.name =~ /[\u4e00-\u9fa5]/
          words_length = @word.name.size
        else
          words_length = @word.name.split(" ").size
        end
        @word.length = words_length
        @word.is_meanful = true
        @word.md1 = word_md[0..7]
        @word.md2 = word_md[8..15]
        @word.md3 = word_md[16..23]
        @word.md4 = word_md[24..31]
        @word.md5 = word_md[32..39]
        @word.md6 = word_md[40..47]
        @word.md7 = word_md[48..55]
        @word.md8 = word_md[56..63]
        @word.save!
        format.html { redirect_to @word, notice: 'Word was successfully updated.' }
        format.json { render :show, status: :ok, location: @word }
      else
        format.html { render :edit }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /words/1
  # DELETE /words/1.json
  def destroy
    redirect_to :back, notice: "您没有权限新建字典，请进行其他操作。"
    # @word.destroy
    # respond_to do |format|
      # format.html { redirect_to words_url, notice: 'Word was successfully destroyed.' }
      # format.json { head :no_content }
    # end
   end

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

  # get /words/1/load_explain_from_baidu_hanyu
  def load_explain_from_baidu_hanyu
    require 'net/http'
    require 'nokogiri'

    @word || @word = Word.find(session[:word_id])

    path = "/zici/s?wd=" + @word.name
    response = Net::HTTP.get_response("hanyu.baidu.com", path)
    if response.body =~ /id="empty-tip"/
      redirect_to :back, notice: "百度词典还没有收录这个词语。"
      return
    end

    a_pattern = Regexp.union(/<a[^>]*>/, /<\/a>/)
    b_pattern = /<b[^>]*>/
    h_pattern = Regexp.union(/<h[^>]*>/, /<\/h[^>]*>/)

    explains = ""
    doc = Nokogiri::HTML(response.body)

    explains <<  doc.css("div#pinyin").inner_html.gsub(a_pattern, "").gsub(b_pattern, "<b>").gsub(h_pattern, "")
    title = doc.css("b.title","b.active")[0].inner_html.gsub(a_pattern, "").gsub(b_pattern, "<b>")
    explains << "<hr><b>" + title + "</b>"
    explains << doc.css("div.en-content","div.tab-content", "div#baike-wrapper")[0].inner_html.gsub(a_pattern, " ").gsub(b_pattern, "<b>").gsub(h_pattern, "") + "<hr>"
    explains <<  doc.css("div#baike-wrapper").inner_html.gsub(a_pattern, " ").gsub(b_pattern, "<b>").gsub(h_pattern, "").gsub("查看百科", "")
    @word.meanings.create(content: explains)
    redirect_to :back, notice: "成功从百度汉语网站导入信息。"
  end

  def new_words_as_tutor
    unless session[:lesson_id]
      redirect_to textbooks_url, notice: "没有找到相应的课文。"
      return
    end
    @lesson = Lesson.find(session[:lesson_id])
    @words = Word.where(id: params[:word_id])
    new_content = "<ol>"
    @words.each do |word|
      new_content << "<li><strong> " + word.name + " </strong>" +  word.phonetics.map{|p|p.content}.to_s.delete("\"") + "<a target=\"_blank\" href=\"/words/" + word.id.to_s + "\" class=\"btn btn-link btn-xs\">查看详细解释</a></li>"
    end
    new_content << "</ol>"
    @tutor = Tutor.create(title: "词汇表", difficulty: 10, page: new_content, user_id: current_user.id, lesson_id: @lesson.id, page_length: new_content.size)
    redirect_to tutor_path(@tutor), notice: "成功生成辅导。"
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word
      @word = Word.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def word_params
      params.require(:word).permit( {id: []},:name, :length, :deleted_at, :is_meanful)
    end
end
