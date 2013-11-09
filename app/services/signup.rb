class Signup

  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def register_user(stripe_token, invitation_token)
    if @user.valid?
      customer = StripeWrapper::Customer.create(:user => @user, :card => stripe_token)
      if customer.successful?
        @user.customer_id = customer.customer_id
        @user.save
        handle_invite(invitation_token)
        AppMailer.notify_on_new_user(@user).deliver
        @status = :success
        self
      else
        @status = :failed
        @error_message = customer.error_message
        self
      end
    else
      @status = :failed
      @error_message = "Invalid user information. Please check the errors below."
      self
    end
  end

  def successful?
    @status == :success
  end

  private 

  def handle_invite(invitation_token)
    if invitation_token.present?
      invite = Invite.where(token: invitation_token).first
      @user.follow(invite.user)
      invite.user.follow(@user)
      invite.update_column(:token, nil)
    end  
  end
end