class WithdrawsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_withdraw, only: [:show, :edit, :update, :destroy]
  before_action :is_cashier

  # GET /withdraws
  # GET /withdraws.json
  def index
    @withdraws = Withdraw.all.page params[:page]
  end

  # GET /withdraws/1
  # GET /withdraws/1.json
  def show
    redirect_to withdraws_path
  end

  # GET /withdraws/new
  def new
    @withdraw = Withdraw.new
    @balance = Receipt.last.balance
  end

  # GET /withdraws/1/edit
  def edit
    redirect_to withdraws_path, notice: "不能更改交款记录。"
  end

  # POST /withdraws
  # POST /withdraws.json
  def create
    @withdraw = Withdraw.new(withdraw_params)
    @withdraw.user_id = current_user.id
    # 结帐取现时必须在receipt表中插入一条记录
    last_balance = Receipt.last.balance
    @receipt = Receipt.new{ |r|
      r.user_id = current_user.id
      r.active_time_before_charge = 0
      r.money = 0 - @withdraw.money
      r.time_length = 0
      r.active_time_after_charge = 0
      r.cashier = 1
      r.balance = last_balance - @withdraw.money
    }
   if @receipt.save
      respond_to do |format|
        if @withdraw.save  
          format.html { redirect_to @withdraw, notice: 'Withdraw was successfully created.' }
          format.json { render :show, status: :created, location: @withdraw }
        else
          format.html { render :new }
          format.json { render json: @withdraw.errors, status: :unprocessable_entity }
        end
     end
    else
      redirect_to withdraws_path, notice: "结款失败。"
    end
  end

  # PATCH/PUT /withdraws/1
  # PATCH/PUT /withdraws/1.json
  def update
    redirect_to withdraws_path, notice: "不能更改交款记录。"
=begin
    respond_to do |format|
      if @withdraw.update(withdraw_params)
        format.html { redirect_to @withdraw, notice: 'Withdraw was successfully updated.' }
        format.json { render :show, status: :ok, location: @withdraw }
      else
        format.html { render :edit }
        format.json { render json: @withdraw.errors, status: :unprocessable_entity }
      end
    end
=end
  end

  # DELETE /withdraws/1
  # DELETE /withdraws/1.json
  def destroy
    redirect_to withdraws_path, notice: "不能更改交款记录。"
=begin
    @withdraw.destroy
    respond_to do |format|
      format.html { redirect_to withdraws_url, notice: 'Withdraw was successfully destroyed.' }
      format.json { head :no_content }
    end
=end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_withdraw
      @withdraw = Withdraw.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def withdraw_params
      params.require(:withdraw).permit(:user_id, :money, :memo, :deleted_at)
    end

    # 只有收款员才能进行master的相关操作
    def is_cashier
      unless Cashier.find_by(user_id: current_user.id)
        redirect_to root_path, notice: "您没有权限。"
      end
    end
 
end
