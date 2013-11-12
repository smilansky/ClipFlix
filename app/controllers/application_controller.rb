class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user, :logged_in?, :require_admin

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:error] = 'You must be logged in'
      redirect_to root_path
    end
  end

  def require_admin
    ((redirect_to home_path) && (flash[:error] = "You are not authorized for this page.")) unless current_user.admin?
  end

end
