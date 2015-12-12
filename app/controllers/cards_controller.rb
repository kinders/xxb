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
    @cardbox = Cardbox.find(session[:cardbox_id])  # 从会话中获取卡片盒号码
    @card = Card.find(session[:card_id])           # 从会话中获取卡片号码
    interval = [10,  20,  40,  180,  360,  720,  1440,  2880,  5760,  11520,  21600]   # 定义学习间隔，单位为分钟：
    # 10分钟，20分钟，40分钟，3小时，6小时，12小时，24小时（1天），48小时（2天），72小时（4天），8天，15天
    interval_str = ["10分钟", "20分钟", "40分钟", "3小时", "6小时", "12小时", "24小时（1天）", "48小时（2天）", "72小时（4天）", "8天", "15天"]
    # 记录足迹
    history = History.create { |h| 
      h.user_id = current_user.id
      h.modelname = "card"
      h.entryid = @card.id
    }
    # 修改本卡信息
    if @card.nexttime > Time.now   ## 如果时间还没到，则什么只是推迟下次复习的时间。就是说，这次学习没有效果。这个if后面的逻辑是指时间到来了。
      @card.nexttime = Time.now + interval[@card.degree - 1] * 60  ### 下次复习时间
    elsif @card.degree == 0        ## 如果级别为0
      @card.nexttime = Time.now + interval[@card.degree] * 60  ### 下次复习时间
      @card.degree += 1                                        ### 下次复习级别
      @card.serial = @cardbox.cards.order(:serial).first(10).last.serial + 1    ### 下次复习顺序
    elsif @card.degree == 10       ## 如果级别为10并且顺序小于二万，嘿嘿，要是复习了兩千次，恐怕就是一个bug了，可是谁会复习兩千次还没有过关呢？等等，这个卡片应该去不出来吧？所以这个判断多余了吧？
      @card.serial += 20000  if @card.serial < 20000      ### 下次复习顺序
    elsif Time.now - @card.nexttime > interval[@card.degree + 1] * 60 && @card.foul < 3   ## 如果复习时超过了限制并且在3次以内。个人觉得超时还答对是个好事，为什么要加以惩罚呢？
      @card.nexttime = Time.now + interval[@card.degree - 1] * 60   ### 下次复习时间
      @card.foul += 1                                           ### 标记本次复习时间超出规定
      @card.serial = @cardbox.cards.order(:serial).first(10).last.serial + 1            ### 将下次复习顺序调整为十张卡片之后
    else                           ## 如果以上情况都不是
      @card.nexttime = Time.now + interval[@card.degree] * 60   ### 下次复习时间
      @card.foul = 0                                            ### 标记本次复习时间合乎规则
      @card.degree += 1                                         ### 下次复习级别
      @card.serial = @cardbox.cards.order(:serial).first(10).last.serial + 1                                         ### 下次复习顺序
    end
    @card.count += 1
    @card.save!
    flash[:notice] = "真棒！下次复习安排在#{interval_str[@card.degree-1]}之后。"
    get_card(@cardbox.id)
  end

  # GET  /cards/1/try_again
  def try_again
    @cardbox = Cardbox.find(session[:cardbox_id])
    @card = Card.find(session[:card_id])
    @card.degree -= 1 unless @card.degree == 0   # 首先是降低复习级别
    @card.nexttime = Time.now                    # 马上安排下次复习
    @card.count += 1                             # 将复习次数加一
    @card.serial = @cardbox.cards.order(:serial).first(4).last.serial + 1                            # 复习顺序加五
    @card.save!
    # 记录足迹
    # history = History.create { |h| 
    #   h.user_id = current_user.id
    #   h.modelname = "card"
    #   h.entryid = @card.id
    # }
    get_card(@cardbox.id)
    flash[:notice] = "没关系！不就再复习一次嘛。"
  end

  # get /cards/1/pass_card
  def pass_card
    @cardbox = Cardbox.find(session[:cardbox_id])
    @card = Card.find(params[:card_id])
    @card.update(degree: 10)
    # 记录足迹
    history = History.create { |h| 
      h.user_id = current_user.id
      h.modelname = "card"
      h.entryid = @card.id
    }
    get_card(@cardbox.id)
  end

  # get /cards/list_right_cards
  def list_right_cards
    right_today_history = History.where(user_id: current_user.id, modelname: "card", created_at: Time.now.beginning_of_day .. Time.now).collect{|h|h.entryid}.uniq
    @right_today_cards = Card.where(id: right_today_history)
  end


  # 在习题 的 index 界面中，将所有习题添加到卡片盒中。
  def add_all_to_cardbox
    begin
      @lesson = Lesson.find(session[:lesson_id])
      @lesson.practices.each do | practice |
        card = Card.new
        card.user_id = current_user.id
        card.practice_id = practice.id
        card.cardbox_id = params[:cardbox_id]
        if Card.where(cardbox_id: params[:cardbox_id]).any?
          card.sequence = Card.where(cardbox_id: params[:cardbox_id]).order(:sequence).last.sequence + 1
        else
          card.sequence = 1
        end
        card.serial = card.sequence.to_f + card.sequence.to_f / 10000
        card.nexttime = Time.now
        card.save
      end
      respond_to do |format|
        format.html { redirect_to :back, notice: '成功将所有习题添加到卡片。' }
        format.json { render :show, status: :created, location: @card }
      end
    rescue 
      respond_to do |format|
        format.html { redirect_to :back, notice: '卡片添加失败，请到卡片盒中检查哪些习题没有添加。' }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end


  private

    # 按卡片的serial的顺序、遍历卡片盒，取出到了时间的下一张卡片
    def get_card(cardbox_id)

      @cardbox_id = cardbox_id
      all_cards = Card.where(cardbox_id: @cardbox_id)
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
        flash[:notice] = "《#{@cardbox.name}》里已经没有卡片值得复习了！"
        else
        @next_time = all_cards.where("nexttime > ?", Time.now ).order(:nexttime).first.nexttime
        flash[:notice] << "恭喜！《#{@cardbox.name}》本轮复习结束，下一轮复习时间为 #{@next_time.strftime("%F %R")}。"
        end
        redirect_to cardboxes_url
      end
    end



    # Use callbacks to share common setup or constraints between actions.
    def set_card
      @card = Card.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def card_params
      params.require(:card).permit(:user_id, :practice_id, :cardbox_id, :sequence, :serial, :degree, :nexttime, :foul, :count, :deleted_at)
      # user_id      用户
      # practice_id  练习题
      # cardbox_id   卡片盒
      # sequence     初始号码
      # serial       顺序号码
      # degree       复习等级
      # nexttime     下次复习时间
      # foul         超时次数
      # count        复习次数
    end
end
