class ReceiptsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_receipt, only: [:show, :edit, :update, :destroy]
  before_action :is_cashier

  # GET /receipts
  # GET /receipts.json
  def index
    @receipts = Receipt.all.page params[:page]
  end

  # GET /receipts/1
  # GET /receipts/1.json
  def show
    redirect_to receipts_path
  end

  # GET /receipts/new
  def new
    @receipt = Receipt.new
  end

  # GET /receipts/1/edit
  def edit
    redirect_to receipts_path, notice: "您不能更改收款记录。"
  end

  # POST /receipts
  # POST /receipts.json
  def create
=begin
    @receipt = Receipt.new(receipt_params)

    respond_to do |format|
      if @receipt.save
        format.html { redirect_to @receipt, notice: 'Receipt was successfully created.' }
        format.json { render :show, status: :created, location: @receipt }
      else
        format.html { render :new }
        format.json { render json: @receipt.errors, status: :unprocessable_entity }
      end
    end
=end
    last_receipt_balance = Receipt.last.balance || 0
    @receipt = Receipt.new(receipt_params)
    @user = User.find(@receipt.cashier)
    @receipt.active_time_before_charge = @user.active_time
    @receipt.time_length = @receipt.money * @receipt.price
    @receipt.active_time_after_charge = @receipt.active_time_before_charge + @receipt.time_length
    @receipt.user_id = current_user.id
    @receipt.balance = last_receipt_balance + @receipt.money
    respond_to do |format|
      if @receipt.save
        @user.update(active_time: @receipt.active_time_after_charge)
        format.html { redirect_to receipts_path, notice: "给用户#{@user.name}充值成功！" }
        format.json { render :show, status: :created, location: @receipt }
      else
        format.html { render :new }
        format.json { render json: @receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /receipts/1
  # PATCH/PUT /receipts/1.json
  def update
=begin
    respond_to do |format|
      if @receipt.update(receipt_params)
        format.html { redirect_to @receipt, notice: 'Receipt was successfully updated.' }
        format.json { render :show, status: :ok, location: @receipt }
      else
        format.html { render :edit }
        format.json { render json: @receipt.errors, status: :unprocessable_entity }
      end
    end
=end
      redirect_to receipts_path, notice: "您不能更改收款记录。如果收款记录有误，请通过新增收款记录来更改。收款金额可以为复数哦，当然也会扣减用户相应的时间。"
  end

  # DELETE /receipts/1
  # DELETE /receipts/1.json
  def destroy
=begin
    @receipt.destroy
    respond_to do |format|
      format.html { redirect_to receipts_url, notice: 'Receipt was successfully destroyed.' }
      format.json { head :no_content }
    end
=end
      redirect_to receipts_path, notice: "您不能删除收款记录。"
  end

  def person_receipts
    @user = User.find(params[:user_id])
    @active_time = @user.active_time
    @receipts = Receipt.where(cashier: @user.id).page params[:page]
  end

  def person_onboards
    @user = User.find(params[:user_id])
    if @user.has_role? :admin
      redirect_to :back, notice: '无法查询该用户的登录记录。'
    else
      @onboards = Onboard.where(user_id: @user.id).page params[:page]
    end
  end

  def who_online
    @onboards = Onboard.where(end_at: nil).page params[:page]
  end

  def off_onboard
    @onboard = Onboard.find(params[:onboard_id])
    @onboard.update(expire_at: Time.now, end_at: Time.now)
    redirect_to :back, notice: "用户 #{@onboard.user.name} 的会话（#{@onboard.id}）已经结束！"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_receipt
      @receipt = Receipt.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def receipt_params
      params.require(:receipt).permit(:user_id, :active_time_before_charge, :money, :time_length, :active_time_after_charge, :cashier, :deleted_at, :price)
    end

  # 只有收款员才能进行master的相关操作
    def is_cashier
      unless Cashier.find_by(user_id: current_user.id)
        redirect_to root_path, notice: "您没有权限。"
      end
    end


end
