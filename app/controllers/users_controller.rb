class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all.order(current_sign_in_at: :desc).page params[:page]
  end

  # GET /users/1
  # GET /users/1.json
  def show
     redirect_to users_path, notice: "您没有权限查看用户信息。"
  end

  # GET /users/new
  def new
     redirect_to new_user_registration_path
  end

  # GET /users/1/edit
  def edit
     redirect_to users_path, notice: "您没有权限修改用户信息。"
  end

  # POST /users
  # POST /users.json
  # def create
  #   @user = User.new(user_params)

  #   respond_to do |format|
  #     if @user.save
  #       format.html { redirect_to @user, notice: 'user was successfully created.' }
  #       format.json { render :show, status: :created, location: @user }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  #def update
  #  respond_to do |format|
  #    if @user.update(user_params)
  #      format.html { redirect_to @user, notice: 'user was successfully updated.' }
  #      format.json { render :show, status: :ok, location: @user }
  #    else
  #      format.html { render :edit }
  #      format.json { render json: @user.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    redirect_to   users_path, notice: "您没有权限删除用户。"
  #   @user.destroy
  #   respond_to do |format|
  #     format.html { redirect_to users_url, notice: 'user was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  end

  def set_vip_user
    @user = User.find(params[:user_id])
    last_receipt_balance = Receipt.last.balance || 0
    @receipt = Receipt.new{ |r|
      r.user_id = 1
      r.active_time_before_charge = @user.active_time
      r.money = 0
      r.time_length = 31622400
      r.cashier = @user.id
      r.active_time_after_charge = 31622400
      r.balance = last_receipt_balance
    }
    @receipt.save
    @user.update(active_time: 31622400, is_vip: true)
    redirect_to users_path, notice: "已经将用户“#{@user.id} #{@user.name}(#{@user.email})”设置为特别用户。"
  end

  def set_normal_user
    @user = User.find(params[:user_id])
    last_receipt_balance = Receipt.last.balance || 0
    @receipt = Receipt.new{ |r|
      r.user_id = 1
      r.active_time_before_charge = @user.active_time
      r.money = 0
      r.time_length = 0 -  @user.active_time
      r.cashier = @user.id
      r.active_time_after_charge = 0
      r.balance = last_receipt_balance
    }
    @receipt.save
    @user.update(active_time: 0, is_vip: nil)
    redirect_to users_path, notice: "已经将用户“#{@user.id} #{@user.name}(#{@user.email})”设置为普通用户。"
  end

  def reset_password
    # 将密码设置为12345678
    @user = User.find(params[:user_id])
    @user.encrypted_password = "$2a$10$eRqrrl5beSXp/7wr9XYMvuFnrjjKVrju7Ii83abfk0t6BnswbcNzG"
    redirect_to users_path, notice: "已经将用户“#{@user.id}  #{@user.name}(#{@user.email}) ”的密码重置为12345678，请通知该用户尽快修改密码！"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email)
    end
end
