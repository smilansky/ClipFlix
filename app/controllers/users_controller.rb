class UsersController < ApplicationController
  before_filter :require_user, only: :show

  def new
    @user = User.new
  end

  def new_with_token
    invite = Invite.where(token: params[:token]).first
    if invite
      @invite_token = invite.token
      @user = User.new(fullname: invite.name, email: invite.email)
      render :new
    else
      redirect_to expired_token_path
    end
  end

  def create
    @user = User.new(params[:user])
    result = Signup.new(@user).register_user(params[:stripeToken], params[:invite_token])
    if result.successful?
      session[:user_id] = @user.id
      flash[:success] = 'Thank you for your generous payment. Welcome to MyFlix!'
      redirect_to home_path
    else
      flash[:error] = result.error_message
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

end