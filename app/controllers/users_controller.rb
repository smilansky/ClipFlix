class UsersController < ApplicationController
  before_filter :require_user, only: :show

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

  def show
    @user = User.find(params[:id])
    binding.pry
  end
end