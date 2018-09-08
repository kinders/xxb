class Users::SessionsController < Devise::SessionsController
  skip_before_action :check_user_active_time
  before_filter :configure_sign_in_params, only: [:create]
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super
  #   Expire.create{|expire|
  #     expire.time = Time.now
  #     expire.user_id = current_user
  #
  #     }
    #登录后检查上一次登录是否退出。在这里可以添加代码，监视用户是否同时在多个设备登录。
    last_onboard = Onboard.where(user_id: current_user.id).last
    if last_onboard
      unless last_onboard.end_at
        last_onboard.update(end_at: Time.now)
        # 下面这一行代码可以阻止用户同时在多个设备上登录：
        # last_onboard.update(end_at: Time.now, expire_at: Time.now)
        a_time =  current_user.active_time - (Time.now - current_user.current_sign_in_at)
        if a_time < 0
          current_user.active_time = 0
        else 
          current_user.active_time = a_time
        end
        current_user.save
      end
    end
    # 创建新的登录记录
    onboard = Onboard.new{ |o|
      o.user_id = current_user.id
      o.begin_at = Time.now 
      o.expire_at = Time.now + current_user.active_time
      o.remote_ip = request.remote_ip
      o.http_user_agent = request.env['HTTP_USER_AGENT']
    }
    onboard.save
    flash[:notice] << "您上次登录时间为#{last_onboard.begin_at}。如果您并没有在时间登录，请与系统管理员联系！"  if last_onboard
  end

  # DELETE /resource/sign_out
  def destroy
    onboard = Onboard.where(user_id: current_user.id).last
    onboard.update(end_at: Time.now)
    a_time =  current_user.active_time - (Time.now - current_user.current_sign_in_at)
    if a_time < 0
      current_user.active_time = 0
    else 
      current_user.active_time = a_time
    end
    current_user.save
    super
  end

  protected

  # You can put the params you want to permit in the empty array.
  def configure_sign_in_params
    # devise_parameter_sanitizer.for(:sign_in) << :attribute
    devise_parameter_sanitizer.permit(:sign_in, keys: [:user, :password])
  end
end
