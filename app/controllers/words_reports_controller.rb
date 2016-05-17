class WordsReportsController < ApplicationController
  skip_before_action :check_user_active_time
  skip_authorization_check
  before_action :set_words_report, only: [:show, :edit, :update, :destroy]

  # GET /words_reports
  # GET /words_reports.json
  # def index
    # @words_reports = WordsReport.all
  # end

  # GET /words_reports/1
  # GET /words_reports/1.json
  def show
    session[:words_report_id] = @words_report.id
    # begin_time = Time.now
    @word_parsers_in_group = WordParser.where(lesson_id: @words_report.lesson_id).select([:word_id]).group(:word_id).count.sort {|a, b| a[1]<=>b[1]}
    # @word_parsers_in_group = WordParser.includes(:word).where(lesson_id: @words_report.lesson_id).where("words.length": 1).select([:word_id]).group(:word_id).count.sort {|a, b| a[1]<=>b[1]}
    # @word_parsers_in_group = WordParser.includes(:words).where("words.length": 1)
    # end_time = Time.now
    # flash[:notice] = "查询耗时#{end_time - begin_time}秒" 
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

  # GET /words_reports/1/show_word2
  def show_word2
    @words_report = WordsReport.find(session[:words_report_id])
    @word_parsers_in_group = WordParser.where(lesson_id: @words_report.lesson_id).select([:word_id]).group(:word_id).count.sort {|a, b| a[1]<=>b[1]}
  end

  # GET /words_reports/1/show_word3
  def show_word3
    @words_report = WordsReport.find(session[:words_report_id])
    @word_parsers_in_group = WordParser.where(lesson_id: @words_report.lesson_id).select([:word_id]).group(:word_id).count.sort {|a, b| a[1]<=>b[1]}
  end

  # GET /words_reports/1/show_word4
  def show_word4
    @words_report = WordsReport.find(session[:words_report_id])
    @word_parsers_in_group = WordParser.where(lesson_id: @words_report.lesson_id).select([:word_id]).group(:word_id).count.sort {|a, b| a[1]<=>b[1]}
  end

  # GET /words_reports/1/show_word5
  def show_word5
    @words_report = WordsReport.find(session[:words_report_id])
    @word_parsers_in_group = WordParser.where(lesson_id: @words_report.lesson_id).select([:word_id]).group(:word_id).count.sort {|a, b| a[1]<=>b[1]}
  end

  # GET /words_reports/1/show_word6
  def show_word6
    @words_report = WordsReport.find(session[:words_report_id])
    @word_parsers_in_group = WordParser.where(lesson_id: @words_report.lesson_id).select([:word_id]).group(:word_id).count.sort {|a, b| a[1]<=>b[1]}
  end

  # GET /words_reports/1/show_word7
  def show_word7
    @words_report = WordsReport.find(session[:words_report_id])
    @word_parsers_in_group = WordParser.where(lesson_id: @words_report.lesson_id).select([:word_id]).group(:word_id).count.sort {|a, b| a[1]<=>b[1]}
  end

  # GET /words_reports/1/show_de1
  def show_de1
    @words_report = WordsReport.find(session[:words_report_id])
    @word_parsers_in_group = WordParser.where(lesson_id: @words_report.lesson_id).select([:word_id]).group(:word_id).count.sort {|a, b| a[1]<=>b[1]}
  end

  # GET /words_reports/1/show_de2
  def show_de2
    @words_report = WordsReport.find(session[:words_report_id])
    @word_parsers_in_group = WordParser.where(lesson_id: @words_report.lesson_id).select([:word_id]).group(:word_id).count.sort {|a, b| a[1]<=>b[1]}
  end

  # GET /words_reports/1/show_de3
  def show_de3
    @words_report = WordsReport.find(session[:words_report_id])
    @word_parsers_in_group = WordParser.where(lesson_id: @words_report.lesson_id).select([:word_id]).group(:word_id).count.sort {|a, b| a[1]<=>b[1]}
  end

  # GET /words_reports/1/show_all_words
  def show_all_words
    @words_report = WordsReport.find(session[:words_report_id])
    @word_parsers_in_group = WordParser.where(lesson_id: @words_report.lesson_id)
  end

  # GET /words_reports/1/show_basic
  def show_basic
    @words_report = WordsReport.find(session[:words_report_id])
    @word_parsers_in_group = WordParser.where(lesson_id: @words_report.lesson_id).select([:word_id]).group(:word_id).count.sort {|a, b| a[1]<=>b[1]}
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
