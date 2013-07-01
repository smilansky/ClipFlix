class VideosController < ApplicationController

  def index
    @videos = Video.all
    @categories = Category.all
  end

  def show
  end

  def edit
  end
end