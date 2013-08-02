class UsersController < ApplicationController
  before_filter :require_user, only: :show

  def new
    @invite = Invite.where(token: params[:format]).first
    @invite? @user = User.new(fullname: @invite.name, email: @invite.email) : @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      if params[:invite_user_id]
        Relationship.create(leader_id: @user.id, user_id: params[:invite_user_id])
        Relationship.create(leader_id: params[:invite_user_id], user_id: @user.id)
      end  
      session[:user_id] = @user.id
      AppMailer.notify_on_new_user(@user).deliver
      redirect_to home_path, notice: "Welcome!"

    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end
end