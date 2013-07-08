class UsersController < ApplicationController

  def new
    if logged_in?
      redirect_to '/home'
    else  
      @user = User.new
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to sign_in_path
    else
      render :new
    end
  end
end