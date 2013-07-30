class ForgotPasswordsController < ApplicationController
  def new
  end

  def create
    @user = User.where(email: params[:email]).first
    if @user
      AppMailer.send_forgot_password(@user).deliver
      redirect_to forgot_password_confirmation_path
    elsif params[:email].blank?
      flash[:error] = "Email cannot be blank"
      redirect_to forgot_password_path 
    else
      flash[:error] = "No user exists with this email address"
      redirect_to forgot_password_path 
    end
  end

  def confirm
  end
end