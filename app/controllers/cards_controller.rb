class CardsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_card, only: [:show, :edit, :update, :destroy]

  # GET /cards
  # GET /cards.json
  def index
    if current_user.has_role? :admin 
      @cards = Card.all
    else
      @cardbox = Cardbox.find(session[:cardbox_id])
      @cards = Card.where(cardbox_id: @cardbox.id).order(:serial)
    end
  end

  # GET /cards/1
  # GET /cards/1.json
  def show
    @practice = @card.practice
    session[:card_id] = @card.id
  end

  # GET /cards/new
  # def new
  #   @card = Card.new
  # end

  # GET /cards/1/edit
  def edit
  end

  # POST /cards
  # POST /cards.json
  def create
    if current_user.has_role? :admin 
      @card = Card.new(card_params)
      respond_to do |format|
        if @card.save
          format.html { redirect_to @card, notice: 'Card was successfully created.' }
          format.json { render :show, status: :created, location: @card }
        else
          format.html { render :new }
          format.json { render json: @card.errors, status: :unprocessable_entity }
        end
      end
    else
      @card = Card.new(card_params)
      @card.user_id = current_user.id
      if Card.where(cardbox_id: card_params[:cardbox_id]).any?
        @card.sequence = Card.where(cardbox_id: card_params[:cardbox_id]).order(:sequence).last.sequence + 1
      else
        @card.sequence = 1
      end
      @card.serial = @card.sequence.to_f + @card.sequence.to_f / 10000
      @card.nexttime = Time.now
      respond_to do |format|
        if @card.save
          format.html { redirect_to :back, notice: '成功添加一张卡片。' }
          format.json { render :show, status: :created, location: @card }
        else
          format.html { redirect_to :back, notice: '卡片添加失败。' }
          format.json { render json: @card.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /cards/1
  # PATCH/PUT /cards/1.json
  def update
    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to @card, notice: 'Card was successfully updated.' }
        format.json { render :show, status: :ok, location: @card }
      else
        format.html { render :edit }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.json
  def destroy
    @card.destroy
    respond_to do |format|
      format.html { redirect_to cards_url, notice: 'Card was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /cards/1/well_done
  def well_done
    @cardbox = Cardbox.find(session[:cardbox_id])
    @card = Card.find(session[:card_id])
    interval = [10,  20,  40,  180,  480,  720,  1440,  2880,  4320,  11520,  21600]   
    if @card.nexttime > Time.now
    elsif @card.degree == 0
      @card.nexttime = Time.now + interval[@card.degree] * 60
      @card.degree += 1
      @card.serial += 10
    elsif @card.degree == 10
      @card.serial += 10000  if @card.serial < 10000
    elsif Time.now - @card.nexttime > interval[@card.degree + 1] * 60 && @card.foul < 10
      @card.nexttime = Time.now + interval[@card.degree] * 60
      @card.foul += 1
      @card.serial += 10
    else
      @card.nexttime = Time.now + interval[@card.degree] * 60
      @card.foul = 0
      @card.degree += 1
      @card.serial += 10
    end
    @card.count += 1
    @card.save!
    # @next_card = Card.where.not("nexttime > #{Time.now}").where(cardbox_id: session[:cardbox_id], user_id: current_user.id).order(:serial).first
    Card.where(cardbox_id: @cardbox.id).order(:serial).each { |card|
      if card.nexttime < Time.now  && card.degree < 10
        @next_card = card
      end
      break if @next_card
    }
    if @next_card
      redirect_to @next_card 
    else
      flash[:notice] = "《#{@cardbox.name}》卡片盒里暂时没有需要复习的卡片"
      redirect_to cardboxes_url
    end
  end

  # GET  /cards/1/try_again
  def try_again
    @cardbox = Cardbox.find(session[:cardbox_id])
    @card = Card.find(session[:card_id])
    @card.degree -= 1 unless @card.degree == 0
    @card.nexttime = Time.now
    @card.count += 1
    @card.serial += 5
    @card.save!
    Card.where(cardbox_id: @cardbox.id).order(:serial).each { |card|
      if card.nexttime < Time.now  && card.degree < 10
        @next_card = card
      end
      break if @next_card
    }
    if @next_card
      redirect_to @next_card 
    else
      flash[:notice] = "《#{@cardbox.name}》卡片盒里暂时没有需要复习的卡片"
      redirect_to cardboxes_url
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_card
      @card = Card.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def card_params
      params.require(:card).permit(:user_id, :practice_id, :cardbox_id, :sequence, :serial, :degree, :nexttime, :foul, :count, :deleted_at)
    end
end
