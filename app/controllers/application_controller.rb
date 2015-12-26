class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_user_active_time
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  check_authorization  :unless => :devise_controller?
  rescue_from CanCan::AccessDenied do | exception |
    begin
      redirect_to :back, alert: "对不起，您的权限不足"
    rescue
      redirect_to root_path, alert: "对不起，您的权限不足"
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password, :password_confirmation, :current_password) }
  end

  def check_user_active_time
    if current_user && current_user.id != 1  # 系统管理员无需检查
      last_onboard = current_user.onboards.last
      # 不能通过检查的第一种情况：用户第一次登录,没有上线时间
      if last_onboard == nil  && current_user.active_time == 0
        sign_out :user
        redirect_to root_path, notice: "您还没有上线时间。请充值后重新登录！"
      # 不能通过检查的第二种情况：老用户登录，已经超过在线逾期时间
      elsif last_onboard
        if last_onboard.expire_at < Time.now  
          last_onboard.update(end_at: Time.now)
          a_time =  current_user.active_time - (Time.now - current_user.current_sign_in_at)
          if a_time < 0
            current_user.active_time = 0
          else 
            current_user.active_time = a_time
          end
          current_user.save
          sign_out :user
          redirect_to root_path, notice: "您的线上时间已经用完。请重新登录或充值！"
        end
      end
    end
  end



end
