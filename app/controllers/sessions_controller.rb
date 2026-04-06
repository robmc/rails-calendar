class SessionsController < ApplicationController

  before_filter :require_no_user, :only => [:new]
  
  def new
  end
  
  def create
    user = User.authenticate(params[:email], params[:password])
      if user
        if params[:remember_me]
          cookies.permanent[:auth_token] = user.auth_token
        else
          cookies[:auth_token] = user.auth_token
        end
        redirect_to calendar_path, (gflash :success)
      else
        render "new", (gflash :error)
      end
  end
  
  def destroy
    cookies.delete(:auth_token)
    redirect_to root_url, (gflash :notice)
  end

end
