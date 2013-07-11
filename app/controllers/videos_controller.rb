class VideosController < ApplicationController
before_filter :require_user

  def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id])
    @reviews = @video.reviews
    binding.pry
  end

  def search 
    @search = Video.search_by_title(params[:search_term])
  end
end