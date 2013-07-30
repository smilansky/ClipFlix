class AppMailer < ActionMailer::Base
  def notify_on_new_user(user)
    @user = user
    mail from: 'dsmilansky@gmail.com', to: @user.email, subject: "Welcome to MyFlix!"
  end

  def send_forgot_password(user)
    @user = user
    mail from: 'dsmilansky@gmail.com', to: @user.email, subject: "Please reset your password"
  end
end