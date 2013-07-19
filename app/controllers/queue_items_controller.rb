class QueueItemsController < ApplicationController
  before_filter :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    queue_video(video)
    redirect_to my_queue_path 
  end

  def destroy
    QueueItem.find(params[:id]).destroy unless QueueItem.find(params[:id]).user != current_user
    current_user.normalize_queue_items
    redirect_to my_queue_path
  end

  def update_queue
    begin 
      update_queue_items
      current_user.normalize_queue_items  
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "You must enter a valid position number"
    end  

    
    redirect_to my_queue_path
  end

  private

  def new_queue_item_position
    current_user.queue_items.count + 1
  end

  def current_user_queued_video?(video)
    current_user.queue_items.map(&:video).include?(video)
  end

  def queue_video(video)
    QueueItem.create(video: video, user: current_user, position: new_queue_item_position) unless current_user_queued_video?(video)
  end  

  def update_queue_items
    ActiveRecord::Base.transaction do
      queue_items = params[:queue_items]
      queue_items.each do |queue_item_data|
        queue_item = QueueItem.find(queue_item_data["id"])
        queue_item.update_attributes!(position: queue_item_data["position"]) unless queue_item.user != current_user
      end
    end
  end   
end