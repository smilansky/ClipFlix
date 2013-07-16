require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do

    it "sets @queue_items to @queue_items of currently logged in user" do
      daniel = Fabricate(:user)
      session[:user_id] = daniel.id
      queue_item1 = Fabricate(:queue_item, user: daniel)
      queue_item2 = Fabricate(:queue_item, user: daniel)
      
      get :index

      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
    it "redirects to the root path for unauthenticate users" do
      get :index
      expect(response).to redirect_to root_path
    end
  end

  describe "POST create" do
    let(:video) { Fabricate(:video) }
    let(:current_user) { Fabricate(:user) }
    context "authenticated user" do
      before do
        session[:user_id] = current_user.id
      end
      it "redirects to the my_queue page" do
        post :create, video_id: video.id, user_id: current_user.id
        expect(response).to redirect_to my_queue_path
      end

      it "creates a new queue item" do
        post :create, video_id: video.id, user_id: current_user.id 
        expect(QueueItem.count).to eq(1)
      end  

      it "creates a new queue item with the associated video" do
        post :create, video_id: video.id, user_id: current_user.id 
        expect(QueueItem.first.video).to eq(video)
      end

      it "creates a new queue item with associated user" do
        post :create, video_id: video.id, user_id: current_user.id
        expect(QueueItem.first.user).to eq(current_user)
      end

      it "puts the video as the last one in the queue" do
        Fabricate(:queue_item, video: video, user: current_user)
        monk = Fabricate(:video)
        post :create, video_id: monk.id, user_id: current_user.id
        monk_queue_item = QueueItem.where(video_id: monk.id, user_id: current_user.id).first
        expect(monk_queue_item.order).to eq(2)
      end

      it "does not add the video to the queue if the video is already in the queue" do
        queue_item1 = Fabricate(:queue_item, video: video, user: current_user)
        post :create, video_id: video.id, user_id: current_user.id
        expect(QueueItem.count).to eq(1)
      end
     end 
    context "unauthenticated user" do
      it "redirects to the root path for unauthenticated users" do
        post :create, video_id: 1
        expect(response).to redirect_to root_path
      end  
    end
  end
end