class CardboxesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_cardbox, only: [:show, :edit, :update, :destroy]

  # GET /cardboxes
  # GET /cardboxes.json
  def index
    session[:cardbox_id] = nil
    if current_user.has_role? :admin
      @cardboxes = Cardbox.all
    elsif session[:lesson_id]
      @lesson = Lesson.find(session[:lesson_id])
      @cardboxes = Cardbox.where(user_id: current_user.id, lesson_id: @lesson.id) 
    elsif session[:textbook_id]
      @textbook = Textbook.find(session[:textbook_id])
      lesson_id_by_serial = Catalog.where(textbook_id: @textbook.id).order(:serial).pluck(:lesson_id)
      @cardboxes = []
      lesson_id_by_serial.each do |lesson_id|
        @cardboxes = @cardboxes + Cardbox.where(user_id: current_user.id, lesson_id: lesson_id).to_a
      end
      # @cardboxes = Cardbox.where(user_id: current_user.id, lesson_id: @textbook.catalogs.map{|c|c.lesson.id}).order(:lesson_id)

    else
      @cardboxes = Cardbox.where(user_id: current_user.id)
    end
  end

  # GET /cardboxes/1
  # GET /cardboxes/1.json
  def show
    session[:cardbox_id] = @cardbox.id
    unless current_user.has_role? :admin
      respond_to do |format|
        format.html { redirect_to cards_path }
      end
    end
  end

  # GET /cardboxes/new
  def new
    @cardbox = Cardbox.new
    @cardbox.lesson_id = session[:lesson_id] if session[:lesson_id]
  end

  # GET /cardboxes/1/edit
  def edit
  end

  # POST /cardboxes
  # POST /cardboxes.json
  def create
    @cardbox = Cardbox.new(cardbox_params)
    @cardbox.user_id = current_user.id
    respond_to do |format|
      if @cardbox.save
        format.html { redirect_to @cardbox, notice: 'Cardbox was successfully created.' }
        format.json { render :show, status: :created, location: @cardbox }
      else
        format.html { render :new }
        format.json { render json: @cardbox.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cardboxes/1
  # PATCH/PUT /cardboxes/1.json
  def update
    respond_to do |format|
      if @cardbox.update(cardbox_params)
        format.html { redirect_to @cardbox, notice: 'Cardbox was successfully updated.' }
        format.json { render :show, status: :ok, location: @cardbox }
      else
        format.html { render :edit }
        format.json { render json: @cardbox.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cardboxes/1
  # DELETE /cardboxes/1.json
  def destroy
    @cardbox.destroy
    respond_to do |format|
      format.html { redirect_to cardboxes_url, notice: 'Cardbox was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def share_cardboxes
    if session[:lesson_id]
      @lesson = Lesson.find(session[:lesson_id])
      @share_cardboxes = Cardbox.where(share: true, lesson_id: @lesson.id)
    elsif session[:textbook_id]
      @textbook = Textbook.find(session[:textbook_id])
      @share_cardboxes = Cardbox.where(share: true, lesson_id: @textbook.catalogs.map{|c|c.lesson.id})
    else
    @share_cardboxes = Cardbox.where(share: true)
    end
  end


  def turn_cards
    @cardbox = Cardbox.find(params[:cardbox_id])
    session[:cardbox_id] = @cardbox.id
    all_cards = Card.where(cardbox_id: @cardbox.id)
    all_cards.order(:serial).each { |card|
      if card.nexttime < Time.now  && card.degree < 10
        @next_card = card
      end
      break if @next_card
    }
    if @next_card
      redirect_to @next_card 
    else
      if  all_cards.collect{|card| card.degree }.uniq == [10]
      flash[:notice] = "《#{@cardbox.name}》里已经没有卡片需要复习了！"
      else
        @next_time = all_cards.where("nexttime > ?", Time.now ).order(:nexttime).first.nexttime
      flash[:notice] = "恭喜！《#{@cardbox.name}》本轮复习结束，下一轮复习时间为 #{@next_time.strftime("%F %R")}！"
      end
      redirect_to cardboxes_url
    end
  end

  def copy_cardbox_for_me
    @cardbox = Cardbox.find(params[:cardbox_id])
    @my_cardbox = Cardbox.create {|cardbox|
      cardbox.user_id = current_user.id
      cardbox.name = @cardbox.name
      cardbox.lesson_id = @cardbox.lesson_id
      cardbox.share = false
    }
    @cardbox.cards.each { |card|
      @my_card = Card.create { |c|
        c.user_id = current_user.id
        c.cardbox_id = @my_cardbox.id
        c.practice_id = card.practice_id
        c.sequence = card.sequence
        c.serial = c.sequence.to_f + c.sequence.to_f / 100000
        c.nexttime = Time.now
      }
    }
    flash[:notice] = "我的《#{@my_cardbox.name}》卡片盒已经准备就绪"
    redirect_to @my_cardbox
  end

  def append_to_cardbox
    begin
      @cardbox = Cardbox.find(params[:dest_id])
      params[:cardbox_id].each do |cardbox_id|
        Cardbox.find(cardbox_id).cards.order(:sequence).each do | card |
          new_card = Card.create { |n_card|
          n_card.user_id = current_user.id
          n_card.practice_id = card.practice_id
          n_card.cardbox_id = @cardbox.id
          if @cardbox.cards.first
            n_card.sequence = @cardbox.cards.order(:sequence).last.sequence + 1
          else
            n_card.sequence = 1
          end
          n_card.serial = n_card.sequence.to_f + n_card.sequence.to_f / 100000
          n_card.nexttime = Time.now
          }
        end
      end
      respond_to do |format|
        format.html { redirect_to cardbox_path(params[:dest_id]), notice: '成功将卡片盒中的习题追加到卡片盒中。' }
        format.json { render :show, status: :created, location: @card }
      end
    rescue 
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, notice: '添加失败，请到卡片盒中检查哪些习题没有添加。' }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cardbox
      @cardbox = Cardbox.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cardbox_params
      params.require(:cardbox).permit( :dest_id, {id: []}, :user_id, :name, :deleted_at, :share, :lesson_id)
    end
end
