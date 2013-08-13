class Admin::VideosController < ApplicationController
 before_filter :require_user
 before_filter :require_admin

  def new
    @video = Video.new
  end


  def create
    @video = Video.new(params[:video])
    if @video.save
      flash[:success] = "You successfully added #{@video.title}!"
      redirect_to admin_add_video_path
    else
      flash[:error] = "You must put in valid parameters to add this video."
      render :new
    end

  end

  private

  def require_admin
    ((redirect_to home_path) && (flash[:error] = "You are not authorized for this page.")) unless current_user.admin?
  end
end