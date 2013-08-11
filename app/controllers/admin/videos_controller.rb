class Admin::VideosController < ApplicationController
 before_filter :require_user
 before_filter :require_admin

  def new
      @video = Video.new
  end

  private

  def require_admin
    ((redirect_to home_path) && (flash[:error] = "You are not authorized for this page.")) unless current_user.admin?
  end
end