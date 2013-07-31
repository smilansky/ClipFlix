class InviteUsersController < ApplicationController
  def create
    @user = User.where(email: params[:friends_email])
    flash[:error] = "Email can't be blank."
    redirect_to invite_path
  end
end