class CardboxesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_cardbox, only: [:show, :edit, :update, :destroy]

  # GET /cardboxes
  # GET /cardboxes.json
  def index
    if current_user.has_role? :admin
      @cardboxes = Cardbox.all
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
    @share_cardboxes = Cardbox.where(share: true)
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
      cardbox.share = false
    }
    @cardbox.cards.each { |card|
      @my_card = Card.create { |c|
        c.user_id = current_user.id
        c.cardbox_id = @my_cardbox.id
        c.practice_id = card.practice_id
        c.sequence = card.sequence
        c.serial = c.sequence.to_f + c.sequence.to_f / 10000
        c.nexttime = Time.now
      }
    }
    flash[:notice] = "我的《#{@my_cardbox.name}》卡片盒已经准备就绪"
    redirect_to @my_cardbox
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cardbox
      @cardbox = Cardbox.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cardbox_params
      params.require(:cardbox).permit(:user_id, :name, :deleted_at, :share)
    end
end
