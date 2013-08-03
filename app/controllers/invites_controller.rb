class InvitesController < ApplicationController
  before_filter :require_user

  def new
    @invite = Invite.new
  end

  def create
    @user = User.where(email: params[:invite][:email])
    @invite = Invite.new(params[:invite].merge!(user_id: current_user.id))
    if @user.blank?
      if @invite.save
        AppMailer.send_invite(@invite).deliver
        flash[:success] = "Your invite was sent!"
        redirect_to home_path
      else
        flash[:error] = @invite.errors
        render :new
      end
    else 
      flash[:error] = "A user with that email address already exists."
      redirect_to invite_path
    end
  end
end