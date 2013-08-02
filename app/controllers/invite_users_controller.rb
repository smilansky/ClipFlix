class InviteUsersController < ApplicationController
  before_filter :require_user

  def new
    @invite = Invite.new
  end

  def create
    @user = User.where(email: params[:email])
    if params[:email].blank? 
      flash[:error] = "Email can't be blank."
      redirect_to invite_path
    elsif @user.blank?
      @invite = Invite.create(email: params[:email], name: params[:name], message: params[:message], user_id: params[:user_id])
      AppMailer.send_invite(@invite).deliver
      redirect_to home_path
    else 
      flash[:error] = "A user with that email address already exists."
      redirect_to invite_path
    end
  end
end