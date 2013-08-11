class SessionsController < ApplicationController  

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to current_user.admin? ? admin_add_video_path : home_path, notice: "Welcome, you have signed in!"
    else
      flash[:error] = "There is something wrong with your username or password"
      redirect_to sign_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "You have logged out!"
  end
end
