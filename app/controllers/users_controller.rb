class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def edit
    @user = User.find_by_auth_token!(cookies[:auth_token])
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url, (gflash :success)
    else
      render "new"
    end
  end
  
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(root_url, (gflash :success)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

end
