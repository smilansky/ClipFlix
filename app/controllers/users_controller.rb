class UsersController < ApplicationController

  def new
    if logged_in?
      redirect_to home_path
    else  
      @user = User.new
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to home_path, notice: "Welcome!"
    else
      render :new
    end
  end

end