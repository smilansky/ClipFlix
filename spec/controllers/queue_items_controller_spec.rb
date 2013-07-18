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
        expect(monk_queue_item.position).to eq(2)
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

  describe "DELETE destroy" do
    context "authenticated user" do
      let(:current_user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:video_queue_item) { Fabricate(:queue_item, video_id: video.id, user_id: current_user.id) }
      before { session[:user_id] = current_user.id}
      it "redirects to the my queue page" do
        delete :destroy, id: video_queue_item.id
        expect(response).to redirect_to my_queue_path
      end

      it "removes a queue item from my queue" do
        delete :destroy, id: video_queue_item.id
        expect(QueueItem.count).to eq(0)
      end

      it "removes a queue item from the queue associated with the signed in user" do
        user = Fabricate(:user)
        video2 = Fabricate(:video)
        video2_queue_item = Fabricate(:queue_item, video_id: video2.id, user_id: user.id)

        delete :destroy, id: video.id
        expect(user.queue_items.count).to eq(1)
      end
    end
    
    context "unauthenticated user" do
      it "redirects to the root_path" do
        delete :destroy, id: 1
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "POST update_queue" do
    context "valid parameters" do
      it "redirects to the my queue page" do
        current_user = Fabricate(:user)
        session[:user_id] = current_user.id
        video_queue_item = Fabricate(:queue_item, user: current_user, position: 1)
        video_queue_item1 = Fabricate(:queue_item, user: current_user, position: 2)
     
        post :update_queue, queue_items: [{id: video_queue_item.id, position: 2}, {id: video_queue_item1.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue_items" do
        current_user = Fabricate(:user)
        session[:user_id] = current_user.id
        video_queue_item = Fabricate(:queue_item, user: current_user, position: 1)
        video_queue_item1 = Fabricate(:queue_item, user: current_user, position: 2)
     
        post :update_queue, queue_items: [{id: video_queue_item.id, position: 2}, {id: video_queue_item1.id, position: 1}]
        expect(current_user.queue_items).to eq([video_queue_item1, video_queue_item])
      end

      it "normalizes the position numbers" do
        current_user = Fabricate(:user)
        session[:user_id] = current_user.id
        video_queue_item = Fabricate(:queue_item, user: current_user, position: 4)
        video_queue_item1 = Fabricate(:queue_item, user: current_user, position: 5)
  
        post :update_queue, queue_items: [{id: video_queue_item.id, position: 3}, {id: video_queue_item1.id, position: 1}]
        video_queue_item.reload
        expect(current_user.queue_items.map(&:position)).to eq([1,2])
      end
      
    end
    context "invalid parameters" do
      it "redirects to the my queue template" do
        current_user = Fabricate(:user)
        session[:user_id] = current_user.id
        video_queue_item = Fabricate(:queue_item, user: current_user, position: 1)
        video_queue_item1 = Fabricate(:queue_item, user: current_user, position: 2)
  
        post :update_queue, queue_items: [{id: video_queue_item.id, position: "" }, {id: video_queue_item1.id, position: 2}]
        expect(response).to redirect_to my_queue_path
      end

      it "sets the flash error message" do
        current_user = Fabricate(:user)
        session[:user_id] = current_user.id
        video_queue_item = Fabricate(:queue_item, user: current_user, position: 1)
        video_queue_item1 = Fabricate(:queue_item, user: current_user, position: 2)
  
        post :update_queue, queue_items: [{id: video_queue_item.id, position: "" }, {id: video_queue_item1.id, position: 2}]
        expect(flash[:errors]).to be_present
      end
      
      it "does not update the position of the queue_items" do
        current_user = Fabricate(:user)
        session[:user_id] = current_user.id
        video_queue_item = Fabricate(:queue_item, user: current_user, position: 1)
        video_queue_item1 = Fabricate(:queue_item, user: current_user, position: 2)
  
        post :update_queue, queue_items: [{id: video_queue_item.id, position: 3.4 }, {id: video_queue_item1.id, position: 2}]
        video_queue_item.reload
        expect(video_queue_item.position).to eq(1)
      end
      

    end  
    context "unauthorized user" do
        it " redirects to the root path"
    end
  end
end