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
    if @user.valid?
      charge = StripeWrapper::Charge.create(:amount => 999, :card => params[:stripeToken])
      if charge.successful?
        @user.save
        handle_invite
        session[:user_id] = @user.id
        AppMailer.notify_on_new_user(@user).deliver
        redirect_to home_path
      else
        flash[:error] = charge.error_message
        render :new
      end
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end


  private

  def handle_invite
    if params[:invite_token].present?
      invite = Invite.where(token: params[:invite_token]).first
      @user.follow(invite.user)
      invite.user.follow(@user)
      invite.update_column(:token, nil)
    end  
  end
end