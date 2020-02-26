class WordsReportsController < ApplicationController
  skip_before_action :check_user_active_time
  skip_authorization_check
  before_action :set_words_report, only: [:show, :edit, :update, :destroy]

  # GET /words_reports
  # GET /words_reports.json
  def index
    @words_reports = WordsReport.all.page(params[:page]).per(100)
  end

  # GET /words_reports/1
  # GET /words_reports/1.json
  def show
    unless WordsReport.find_by(id: @words_report.id)
      redirect_back fallback_location: root_path, notice: "相关报告已被删除。"
    end
    session[:words_report_id] = @words_report.id
    all_words = WordParser.where(lesson_id: @words_report.lesson_id).pluck(:word_id).uniq
    @longest = Word.where(id: all_words).maximum(:length)
    @word_parsers_in_group = WordParser.where(lesson_id: @words_report.lesson_id).order("id").page(params[:page]).per(100)
    # word_parsers_in_group = WordParser.includes("word").where(lesson_id: @words_report.lesson_id, words: {length: 1}).select([:word_id]).group(:word_id).count.sort {|a, b| a[1]<=>b[1]}
    # @word_parsers_in_group = Kaminari.paginate_array(word_parsers_in_group).page(params[:page]).per(10)
  end

  # GET /words_reports/new
  # def new
    # @words_report = WordsReport.new
  # end

  # GET /words_reports/1/edit
  # def edit
  # end

  # POST /words_reports
  # POST /words_reports.json
  # def create
    # @words_report = WordsReport.new(words_report_params)

    # respond_to do |format|
      # if @words_report.save
        # format.html { redirect_to @words_report, notice: 'Words report was successfully created.' }
        # format.json { render :show, status: :created, location: @words_report }
      # else
        # format.html { render :new }
        # format.json { render json: @words_report.errors, status: :unprocessable_entity }
      # end
    # end
  # end

  # PATCH/PUT /words_reports/1
  # PATCH/PUT /words_reports/1.json
  # def update
    # respond_to do |format|
      # if @words_report.update(words_report_params)
        # format.html { redirect_to @words_report, notice: 'Words report was successfully updated.' }
        # format.json { render :show, status: :ok, location: @words_report }
      # else
        # format.html { render :edit }
        # format.json { render json: @words_report.errors, status: :unprocessable_entity }
      # end
    # end
  # end

  # DELETE /words_reports/1
  # DELETE /words_reports/1.json
  # def destroy
    # @words_report.destroy
    # respond_to do |format|
      # format.html { redirect_to words_reports_url, notice: 'Words report was successfully destroyed.' }
      # format.json { head :no_content }
    # end
  # end

  # GET /words_reports/1/show_word_n
  def show_word_n
    @words_report = WordsReport.find(params[:words_report_id])
    all_words = WordParser.where(lesson_id: @words_report.lesson_id).pluck(:word_id).uniq
    @longest = Word.where(id: all_words).maximum(:length) || 1
    @num = params[:num] || 1
    word_parsers_in_group = WordParser.includes("word").where(lesson_id: @words_report.lesson_id, words: {length: @num}).group(:word_id).count.sort {|a, b| a[1]<=>b[1]}
    @word_parsers_in_group = Kaminari.paginate_array(word_parsers_in_group).page(params[:page]).per(100)
  end

  # GET /words_reports/1/show_de1
  def show_de1
    @words_report = WordsReport.find(params[:words_report_id])
    all_words = WordParser.where(lesson_id: @words_report.lesson_id).pluck(:word_id).uniq
    @longest = Word.where(id: all_words).maximum("length")
    # @word_parsers_in_group = WordParser.where(lesson_id: @words_report.lesson_id).select([:word_id]).group(:word_id).count.sort {|a, b| a[1]<=>b[1]}
    @word_parsers_in_group = WordParser.where(lesson_id: @words_report.lesson_id).select([:word_id]).group(:word_id).count
    # word_parsers_in_group = WordParser.where(lesson_id: @words_report.lesson_id).pluck("word_id")
  end

  # GET /words_reports/1/show_de2
  def show_de2
    @words_report = WordsReport.find(params[:words_report_id])
    all_words = WordParser.where(lesson_id: @words_report.lesson_id).pluck(:word_id).uniq
    @longest = Word.where(id: all_words).maximum("length")
    @word_parsers_in_group = WordParser.where(lesson_id: @words_report.lesson_id).select([:word_id]).group(:word_id).count.sort {|a, b| a[1]<=>b[1]}
  end

  # GET /words_reports/1/show_de3
  def show_de3
    @words_report = WordsReport.find(params[:words_report_id])
    all_words = WordParser.where(lesson_id: @words_report.lesson_id).pluck(:word_id).uniq
    @longest = Word.where(id: all_words).maximum("length")
    @word_parsers_in_group = WordParser.where(lesson_id: @words_report.lesson_id).select([:word_id]).group(:word_id).count.sort {|a, b| a[1]<=>b[1]}
  end

  # GET /words_reports/1/show_basic
  # 词条统计分析
  def show_basic
    @words_report = WordsReport.find(params[:words_report_id])
    all_words = WordParser.where(lesson_id: @words_report.lesson_id).pluck(:word_id).uniq
    @longest = Word.where(id: all_words).maximum(:length) || 1
    word_parsers_in_group = WordParser.where(lesson_id: @words_report.lesson_id).select([:word_id]).group(:word_id).count.sort {|a, b| a[1]<=>b[1]}
    @word_parsers_in_group = Kaminari.paginate_array(word_parsers_in_group).page(params[:page]).per(100)

  end

  # GET /words_reports/compare_with_another
  def compare_with_another
    # @words_report = WordsReport.find(session[:words_report_id])
    # @lesson = Lesson.find(@words_report.lesson_id)
    @lesson = Lesson.find(session[:lesson_id])
  end

  # GET /words_reports/compare_report
  def compare_report
    @words_report = WordsReport.find(session[:words_report_id])
    @lesson = Lesson.find(session[:lesson_id])
    @lesson_2 = Lesson.find(params[:lesson_id])
    unless WordsReport.find_by(lesson_id: params[:lesson_id])
      redirect_back fallback_location: root_path, notice: "还未对《#{@lesson_2.title}》进行分析，暂时无法比较。"
      return
    end
    words_from_lesson_1 = WordParser.includes(:word).where(lesson_id: @lesson.id, words: {is_meanful: true}).map{|word_parser|word_parser.word_id}
    words_from_lesson_2 = WordParser.includes(:word).where(lesson_id: @lesson_2.id, words: {is_meanful: true}).map{|word_parser|word_parser.word_id}
    @same_words = words_from_lesson_1 & words_from_lesson_2
    @diff_words_from_lesson1 =  words_from_lesson_1 - words_from_lesson_2
    @diff_words_from_lesson2 =  words_from_lesson_2 - words_from_lesson_1
    @same_in_lesson_1 = @same_words.size.to_f * 100  / (@diff_words_from_lesson1.size + @same_words.size)
    @same_in_lesson_2 = @same_words.size.to_f * 100  / (@diff_words_from_lesson2.size + @same_words.size)
  end

  def show_unmeanful_words
    @words_report = WordsReport.find(params[:words_report_id])
    all_words = WordParser.where(lesson_id: @words_report.lesson_id).pluck("word_id").uniq
    word_parsers_in_group = []
    Word.where(id: all_words, is_meanful: nil).order("length").each do |word|
      word_count = word.word_parsers.where(lesson_id: @words_report.lesson_id).size
      word_parsers_in_group << [word.id, word_count]
    end
    @word_parsers_in_group = Kaminari.paginate_array(word_parsers_in_group).page(params[:page]).per(100)
  end

  def show_meanful_words
    @words_report = WordsReport.find(params[:words_report_id])
    all_words = WordParser.where(lesson_id: @words_report.lesson_id).pluck("word_id").uniq
    # 下面是将词语按词语的长度进行排列。
    # @word_parsers_in_group = Word.where(id: all_words, is_meanful: true).order("length").page(params[:page]).per(10)
    # 下面词语的排序规则是：首先按出现的频率，然后按词语的长度。
    word_parsers_in_group = []
    Word.where(id: all_words, is_meanful: true).order("length").each do |word|
      word_count = word.word_parsers.where(lesson_id: @words_report.lesson_id).size
      word_parsers_in_group << [word.id, word_count]
    end
    word_parsers_in_group.sort! {|a, b| a[1]<=>b[1]}
    @word_parsers_in_group = Kaminari.paginate_array(word_parsers_in_group).page(params[:page]).per(100)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_words_report
      @words_report = WordsReport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def words_report_params
      params.require(:words_report).permit(:lesson_id, :md, :deleted_at)
    end
end
