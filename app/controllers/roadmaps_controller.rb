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
    # lesson_ids = @roadmap.lessons.pluck(:id)
    lesson_ids = Pace.where(roadmap: @roadmap.id, serial: params[:pace_begin_id]..params[:pace_end_id]).pluck(:lesson_id)
    all_words = WordParser.where(lesson_id: lesson_ids).pluck("word_id").uniq
    @word_parsers_in_group = Word.where(id: all_words, length: 1)#page(params[:page]).per(100)
    # @word_parsers_in_group = Word.where(id: all_words, length: 1).page(params[:page]).per(100)
  end

  ### 按字频率排序
  def single_words_in_freq
    @roadmap = Roadmap.find(session[:roadmap_id])
    # lesson_ids = @roadmap.lessons.pluck(:id)
    lesson_ids = Pace.where(roadmap: @roadmap.id, serial: params[:pace_begin_id]..params[:pace_end_id]).pluck(:lesson_id)
    all_words = WordParser.includes(:word).where(lesson_id: lesson_ids, words: {length: 1}).pluck("word_id")
    # @word_parsers_in_group = all_words.group_by {|word| [word, all_words.count(word)]}.keys.sort {|a, b| a[1]<=>b[1]}
    word_in_group = all_words.group_by {|word| word}
    word_parsers_in_group = []
    word_in_group.each do |w|
      word_parsers_in_group << [w[0], w[1].size]
    end
    @word_parsers_in_group = word_parsers_in_group.sort{|a, b| a[1]<=>b[1]}
  end

  # 文路的字词排序
  def meanful_words_in_line
    @roadmap = Roadmap.find(session[:roadmap_id])
    lesson_ids = Pace.where(roadmap: @roadmap.id, serial: params[:pace_begin_id]..params[:pace_end_id]).pluck(:lesson_id)
    all_words = []
    if params[:length_end] == "1"
      all_words = WordParser.includes(:word).where(lesson_id: lesson_ids, words: {length: 1}).pluck("word_id")
    else 
      params[:length_start] = "2" if params[:length_start].to_i == "1"
      params[:length_end] = "10" if params[:length_end].to_i > "10"
      all_words = WordParser.includes(:word).where(lesson_id: lesson_ids, words: {length: (params[:length_start].to_i)..(params[:length_end].to_i), is_meanful: true}).pluck("word_id")
    end
    # logger.fatal("all_words:" + all_words.size.to_s)
    all_word_id_and_location = []  # [[word_id, location], [word_id, location]...]
    all_words.each_with_index do |w, i|
      all_word_id_and_location << [w, i]
    end
    # logger.fatal("all_word_id_and_location:" + all_word_id_and_location.size.to_s)
    word_and_location_in_group = all_word_id_and_location.group_by{|i|i[0]}.map{|i|[i[0], i[1].map{|j|j[1]}]}  # [[word_id, [location1, location2...]], [word_id, [location1, location2...]]... ]
    # logger.fatal("word_and_location_in_group:" + word_and_location_in_group.size.to_s)
    word_and_score = word_and_location_in_group.map{|i| [i[0], i[1].inject(:+)]}
    #=> [[word_id, score], [word_id, score]...] 
    # logger.fatal("word_and_score:" + word_and_score.size.to_s)
    word_ids = word_and_score.map{|i|i[0]} # [word_id, word_id...]
    word_scores = word_and_score.map{|i|i[1]} # [score, score...]
    word_and_count = word_and_location_in_group.map{|i| [i[1].size, i[0]]} #=> [[size, word_id], [size, word_id]...] 
    word_and_size_in_group = word_and_count.group_by{|i|i[0]}.map{|i|[i[0], i[1].map{|j|j[1]}]}  # [[size, [word_id1, word_id2...]], [size, [word_id1, word_id2...]]... ]
    word_and_size_in_order = word_and_size_in_group.sort{|a, b| a[0]<=>b[0]}.reverse  # [[size, [word_id1, word_id2...]], [size, [word_id1, word_id2...]]... ]
    @word_parsers_in_group = []
    word_and_size_in_order.each do |i|
      @word_parsers_in_group << i[1].sort{|a, b| word_scores[word_ids.index(a)] <=> word_scores[word_ids.index(b)]}
    end
    wordmap_name = @roadmap.name + "_pace_" + params[:pace_begin_id] + "_" + params[:pace_end_id] + "_length_" + params[:length_start] + "_" + params[:length_end] +  "_词序表_" + Time.now.strftime("%F %T")
    @wordmap = Wordmap.create(user_id: current_user.id, roadmap_id: @roadmap.id, name: wordmap_name)
    wordorders = []
    @word_parsers_in_group.flatten!
    # logger.fatal("word_parsers_in_group:" + @word_parsers_in_group.size.to_s)
    word_parsers_in_group_size = @word_parsers_in_group.size
    @word_parsers_in_group.each_with_index {|w, i|
      j = i + 1
      wordorders << {user_id: current_user.id, wordmap_id: @wordmap.id, word_id: w, serial: j}
      if ( j % 500 ) == 0  || j == word_parsers_in_group_size
        Wordorder.create(wordorders)
        wordorders = []
      end
    }
    redirect_to wordmap_url(@wordmap), notice: '成功生成词序表！'
  end

  # 文路的用词报告。
  ## 包含两个部分：按字排序，按频排序。
  ### 按字排序
  def meanful_words
    @roadmap = Roadmap.find(session[:roadmap_id])
    lesson_ids = Pace.where(roadmap: @roadmap.id, serial: params[:pace_begin_id]..params[:pace_end_id]).pluck(:lesson_id)
    # lesson_ids = @roadmap.lessons.pluck(:id)
    all_words = WordParser.where(lesson_id: lesson_ids).pluck("word_id").uniq
    @word_parsers_in_group = Word.where(id: all_words, length: [2..100], is_meanful: true).order(:name)
    # @word_parsers_in_group = Word.where(id: all_words, length: [2..100], is_meanful: true).order(:name).page(params[:page]).per(100)
  end

  ### 按频排序
  def meanful_words_in_freq
    @roadmap = Roadmap.find(session[:roadmap_id])
    # lesson_ids = @roadmap.lessons.pluck(:id)
    lesson_ids = Pace.where(roadmap: @roadmap.id, serial: params[:pace_begin_id]..params[:pace_end_id]).pluck(:lesson_id)
    all_words = WordParser.includes(:word).where(lesson_id: lesson_ids, words: {length: 2..100, is_meanful: true}).pluck("word_id")
    # @word_parsers_in_group = all_words.group_by {|word| [word, all_words.count(word)]}.keys.sort {|a, b| a[1]<=>b[1]}
    word_in_group = all_words.group_by {|word| word}
    word_parsers_in_group = []
    word_in_group.each do |w|
      word_parsers_in_group << [w[0], w[1].size]
    end
    @word_parsers_in_group = word_parsers_in_group.sort{|a, b| a[1]<=>b[1]}
    # word_parsers_in_group = all_words.group_by {|word| [word, all_words.count(word)]}.keys.sort {|a, b| a[1]<=>b[1]}

    # @word_parsers_in_group = Kaminari.paginate_array(word_parsers_in_group).page(params[:page]).per(100)
  end

  def choose_begin_and_end
    unless session[:lesson_id]
      redirect_to :back, notice: "请先指定一个课程"
      return
    end
    @lesson = Lesson.find(session[:lesson_id])
    @roadmap = Roadmap.find(params[:roadmap_id])
    session[:roadmap_id] = params[:roadmap_id]
    if Pace.find_by(lesson_id: @lesson.id, roadmap_id: @roadmap.id, serial: 1)
      redirect_to lesson_url(@lesson), notice: "“#{@roadmap.name}”的起点太高，暂时无法比较，请重新选择一个较低的标准。"
    end
  end

  def compare_with_roadmap
    @roadmap = Roadmap.find(session[:roadmap_id])
    @pace_begin = Pace.find_by(roadmap_id: @roadmap.id, serial: params[:pace_begin_id])
    @pace_end = Pace.find_by(roadmap_id: @roadmap.id, serial: params[:pace_end_id])
    roadmap_lessons_id = Pace.where(roadmap_id: @roadmap.id, serial: params[:pace_begin_id]..params[:pace_end_id]).pluck(:lesson_id)
    @lesson = Lesson.find(session[:lesson_id])
    words_from_lesson_1 = WordParser.includes(:word).where(lesson_id: @lesson.id, words: {is_meanful: true}).map{|word_parser|word_parser.word_id}.uniq
    words_from_lesson_2 = WordParser.includes(:word).where(lesson_id: roadmap_lessons_id, words: {is_meanful: true}).map{|word_parser|word_parser.word_id}.uniq
    @same_words = (words_from_lesson_1 & words_from_lesson_2).sort
    @diff_words_from_lesson1 =  (words_from_lesson_1 - words_from_lesson_2).sort
    @same_in_lesson_1 = @same_words.size.to_f * 100  / words_from_lesson_1.size
    @same_in_lesson_2 = @same_words.size.to_f * 100  / words_from_lesson_2.size
  end

  def word_first_appear
    @roadmap = Roadmap.find(session[:roadmap_id])
    @pace_begin = Pace.find(params[:pace_begin_id])
    @pace_end = Pace.find(params[:pace_end_id])
    @result = []
    word_id_list = []
    @roadmap.paces.where(serial: @pace_begin..@pace_end).each do |pace|
      word_id_origin << pace.lesson.word_parsers.map {|word_parser| word_parser.word_id}.uniq # 生成word的id列表
      word_id_origin.each do |word_id_o|
        if @pace_end.include?(word_id_o)
          @pace_end << word_id_o
          @result << [word_id_o, pace]
        else
          next
        end
      end
      # 将生成元素[word_id, pace.serial]组成的结果数组
      #  将每个word_id和word_id_list相比，如果在里面则跳过，如果没有则加入word_id_list和结果数组
    end 
    # lesson_ids = Pace.where(roadmap: @roadmap.id, serial: params[:pace_begin_id]..params[:pace_end_id]).pluck(:lesson_id)
    # all_words = WordParser.includes(:word).where(lesson_id: lesson_ids, words: {length: 2..100, is_meanful: true}).pluck("word_id")
    # @word_parsers_in_group = all_words.group_by {|word| [word, all_words.count(word)]}.keys.sort {|a, b| a[1]<=>b[1]}
  end

  # 直接为课本生成文路
  def create_roadmap_for_textbook
    unless session[:textbook_id]
      redirect_to :back, notice: "无法找到对应的课文"
      return
    else
      @textbook = Textbook.find(session[:textbook_id])
      @roadmap = Roadmap.create(name: @textbook.title, description: @textbook.description, user_id: @textbook.user_id, textbook_id: @textbook.id)
      @textbook.catalogs.order(:serial).map{|c|c.lesson_id}.each do |lesson|
        Pace.create {|pace|
          pace.user_id = @roadmap.user_id
          pace.roadmap_id = @roadmap.id
          pace.lesson_id = lesson
          if @roadmap.paces.any?
            pace.serial = @roadmap.paces.order(:serial).last.serial + 1
          else
            pace.serial = 1
          end
        }
      end
      respond_to do |format|
        format.html { redirect_to roadmap_path(@roadmap), notice: '成功生成文路。' }
      end
    end
  end

  # 更新课本的文路
  def update_roadmap_for_textbook
    @roadmap = Roadmap.find(session[:roadmap_id])
    paces_lesson_ids = @roadmap.paces.map{|p| p.lesson_id}
    lesson_ids = @roadmap.textbook.catalogs.order(:serial).map{|c|c.lesson_id}
    void_lesson_ids = paces_lesson_ids - lesson_ids
    lesson_ids.each_with_index do |lesson, index|
      old_pace = Pace.find_by(roadmap_id: @roadmap.id, lesson_id: lesson)
      if old_pace 
        if old_pace.serial == (index + 1)
          next
        else
          old_pace.update(serial: (index + 1)) 
        end
      else
        Pace.create(user_id: @roadmap.user_id, roadmap_id: @roadmap.id, lesson_id: lesson, serial: (index + 1))
      end
    end 
    Pace.where(roadmap_id: @roadmap, lesson_id: void_lesson_ids).destroy_all
    respond_to do |format|
      format.html { redirect_to roadmap_path(@roadmap), notice: '文路完成更新。' }
    end
  end

  def copy_to_new_roadmap
    @roadmap = Roadmap.find_by(id: params[:roadmap_id])
    unless @roadmap
      redirect_to :back, notice: '无法找到要复制的指定文路'
      return
    end
    new_roadmap = Roadmap.create(name: @roadmap.name + Time.now.to_s, description: @roadmap.description, user_id: current_user.id, textbook_id: @roadmap.textbook_id)
    @roadmap.paces.each do |pace|
      Pace.create(user_id: current_user.id, roadmap_id: new_roadmap.id, lesson_id: pace.lesson_id, serial: pace.serial)
    end
    redirect_to :back, notice: '成功复制文路'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_roadmap
      @roadmap = Roadmap.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def roadmap_params
      params.require(:roadmap).permit(:name, :description, :user_id, :deleted_at, :textbook_id)
    end
end
