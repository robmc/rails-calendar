class ApplicationController < ActionController::Base
  protect_from_forgery
  
  around_filter :user_time_zone, if: :current_user

  private
  
  def current_user
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end
  helper_method :current_user
  
  def require_no_user
    if current_user
      redirect_to calendar_path
      return false
    end
  end
  
  def require_user
    if current_user == nil
      redirect_to log_in_path, :notice => "You must be logged in to do that!"
      return false
    end
  end
  
  def user_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
end
