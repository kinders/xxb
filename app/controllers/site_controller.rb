class SiteController < ApplicationController
  skip_before_action :check_user_active_time
  skip_authorization_check
  def home
  end
end
