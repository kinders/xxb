class WordmapsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_wordmap, only: [:show, :edit, :update, :destroy]

  # GET /wordmaps
  # GET /wordmaps.json
  def index
    session[:wordmap_id] = nil
    if current_user.has_role? :admin
      @wordmaps = Wordmap.all.order("id")
    elsif session[:roadmap_id]
      @roadmap = Roadmap.find_by(id: session[:roadmap_id])
      @wordmaps = Wordmap.where(user_id: current_user.id, roadmap_id: session[:roadmap_id]).order("id")
    else
      @wordmaps = Wordmap.where(user_id: current_user.id).order("id")
    end
  end

  # GET /wordmaps/1
  # GET /wordmaps/1.json
  def show
    session[:wordmap_id] = @wordmap.id
    unless current_user.has_role? :admin
      respond_to do |format|
        format.html { redirect_to wordorders_path }
      end
    end
  end

# =begin
  # GET /wordmaps/new
  def new
    @wordmap = Wordmap.new
  end

  # GET /wordmaps/1/edit
  def edit
  end

  # POST /wordmaps
  # POST /wordmaps.json
  def create
    @wordmap = Wordmap.new(wordmap_params)
    @wordmap.user_id = current_user.id
    if session[:roadmap_id]
      @wordmap.roadmap_id = session[:roadmap_id]
    end

    respond_to do |format|
      if @wordmap.save
        format.html { redirect_to @wordmap, notice: 'Wordmap was successfully created.' }
        format.json { render :show, status: :created, location: @wordmap }
      else
        format.html { render :new }
        format.json { render json: @wordmap.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wordmaps/1
  # PATCH/PUT /wordmaps/1.json
  def update
    respond_to do |format|
      if @wordmap.update(wordmap_params)
        format.html { redirect_to @wordmap, notice: 'Wordmap was successfully updated.' }
        format.json { render :show, status: :ok, location: @wordmap }
      else
        format.html { render :edit }
        format.json { render json: @wordmap.errors, status: :unprocessable_entity }
      end
    end
  end
# =end

  # DELETE /wordmaps/1
  # DELETE /wordmaps/1.json
  def destroy
    @wordmap.destroy
    respond_to do |format|
      format.html { redirect_to wordmaps_url, notice: 'Wordmap was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # post export_wordmaps_to_cardbox[:wordmap_id]
  def export_wordmaps_to_cardbox
    # begin
      @wordmap = Wordmap.find(params[:wordmap_id])
      if @wordmap.wordorders.any?
        @cardbox = Cardbox.create { |c|
          c.user_id = current_user.id
          c.name = @wordmap.name + Time.now.strftime("%F %T")
          c.lesson_id = 21143  # 暂时指定21143课程为所有字词练习的归属，更好的方式可能是为cardbox的lesson_id字段分割为type,type_id两个字段
          c.share = true if Master.find_by(id: current_user.id)
        }
        @wordmap.wordorders.order(:serial).each_with_index {|w, i|
          Card.create {|card|
            card.user_id = current_user.id
            word_name = w.word.name
            practice = Practice.find_by(labelname: 'wordmap', question: word_name)
            unless practice
              word_phonetics = w.word.phonetics.map{|p| p.content}.join(",")
              word_meanings = w.word.meanings.map{|m| m.content}.join("\r")
              word_phonetics_and_meanings = word_phonetics + '<hr>' + word_meanings
              practice = Practice.create(user_id: current_user.id, labelname: 'wordmap', title: '读准发音，解释意思', question: word_name, answer: word_phonetics_and_meanings, score: 1)
            end
            card.practice_id = practice.id
            card.cardbox_id = @cardbox.id
            card.degree = 0
            card.nexttime = Time.now
            card.foul = 0
            card.count = 0
            card.sequence =  i + 1
            card.serial = card.sequence.to_f + card.sequence.to_f / 10000
          }
        }
        respond_to do |format|
          format.html { redirect_to :back, notice: "习题已经被成功添加到卡片盒“#{@cardbox.name}”（#{@cardbox.id}）中。" }
          format.json { render json: @card.errors, status: :unprocessable_entity }
        end
      else
        respond_to do |format|
          format.html { redirect_to :back, notice: '这个词序表里面没有词语，请先添加词语' }
          format.json { render json: @card.errors, status: :unprocessable_entity }
        end
      end
=begin
    rescue
      respond_to do |format|
        format.html { redirect_to :back, notice: '习题添加出错，请在卡片盒中检查哪些词语没有被添加到卡片盒中。' }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
=end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wordmap
      @wordmap = Wordmap.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wordmap_params
      params.require(:wordmap).permit(:user_id, :roadmap_id, :name, :deleted_at)
    end
end
