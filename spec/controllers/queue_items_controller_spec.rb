require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do

    it "sets @queue_items to @queue_items of currently logged in user" do
      set_current_user
      queue_item1 = Fabricate(:queue_item, user: current_user)
      queue_item2 = Fabricate(:queue_item, user: current_user)
      
      get :index

      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
    it_behaves_like "require_sign_in" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    let(:video) { Fabricate(:video) }
    context "authenticated user" do
      before { set_current_user }
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
      it_behaves_like "require_sign_in" do
        let(:action) { post :create, video_id: 1 }
      end  
    end
  end

  describe "DELETE destroy" do
    context "authenticated user" do
      let(:video) { Fabricate(:video) }
      let(:video_queue_item) { Fabricate(:queue_item, video_id: video.id, user_id: current_user.id) }
      before { set_current_user }
      it "redirects to the my queue page" do
        delete :destroy, id: video_queue_item.id
        expect(response).to redirect_to my_queue_path
      end

      it "removes a queue item from my queue" do
        delete :destroy, id: video_queue_item.id
        expect(QueueItem.count).to eq(0)
      end

      it "normalizes the remaining queue items" do
        video_queue_item = Fabricate(:queue_item, user: current_user, position: 1)
        video_queue_item1 = Fabricate(:queue_item, user: current_user, position: 2)

        delete :destroy, id: video_queue_item.id
        expect(video_queue_item1.reload.position).to eq(1)
      end

      it "removes a queue item from the queue associated with the signed in user" do
        user = Fabricate(:user)
        video2 = Fabricate(:video)
        video2_queue_item = Fabricate(:queue_item, video_id: video2.id, user_id: user.id)

        delete :destroy, id: video2_queue_item.id
        expect(user.queue_items.count).to eq(1)
      end
    end
    
    context "unauthenticated user" do
      it_behaves_like "require_sign_in" do
        let(:action) { delete :destroy, id: 1 }
      end
    end
  end

  describe "POST update_queue" do
    context "valid parameters" do
        let(:video) { Fabricate(:video) }
        let(:video_queue_item) { Fabricate(:queue_item, user: current_user, position: 1, video: video) }
        let(:video_queue_item1) { Fabricate(:queue_item, user: current_user, position: 2, video: video) }
        before { set_current_user }
      it "redirects to the my queue page" do     
        post :update_queue, queue_items: [{id: video_queue_item.id, position: 2}, {id: video_queue_item1.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue_items" do     
        post :update_queue, queue_items: [{id: video_queue_item.id, position: 2}, {id: video_queue_item1.id, position: 1}]
        expect(current_user.queue_items).to eq([video_queue_item1, video_queue_item])
      end

      it "normalizes the position numbers" do  
        post :update_queue, queue_items: [{id: video_queue_item.id, position: 3}, {id: video_queue_item1.id, position: 1}]
        video_queue_item.reload
        expect(current_user.queue_items.map(&:position)).to eq([1,2])
      end   

    end

    context "invalid parameters" do
        let(:video) { Fabricate(:video) }
        let(:video_queue_item) { Fabricate(:queue_item, user: current_user, position: 1, video: video) }
        let(:video_queue_item1) { Fabricate(:queue_item, user: current_user, position: 2, video: video) }
        before { set_current_user}
        
      it "redirects to the my queue template" do  
        post :update_queue, queue_items: [{id: video_queue_item.id, position: "" }, {id: video_queue_item1.id, position: 2}]
        expect(response).to redirect_to my_queue_path
      end

      it "sets the flash error message" do  
        post :update_queue, queue_items: [{id: video_queue_item.id, position: "" }, {id: video_queue_item1.id, position: 2}]
        expect(flash[:error]).to be_present
      end
      
      it "does not update the position of the queue_items" do  
        post :update_queue, queue_items: [{id: video_queue_item.id, position: 3 }, {id: video_queue_item1.id, position: 1.2}]
        expect(video_queue_item1.reload.position).to eq(2)
      end
      

    end  
    context "unauthorized user" do
        let(:video_queue_item) { Fabricate(:queue_item) }
        let(:video_queue_item1) { Fabricate(:queue_item) }
        it_behaves_like "require_sign_in" do 
          let(:action) {post :update_queue, queue_items: [{ id: video_queue_item.id}, { id: video_queue_item1.id}] }
        end  
    end

    context "with queueitems that do not belong to the current user" do
      it "does not change the queue items" do
        set_current_user  
        user = Fabricate(:user)
        video_queue_item = Fabricate(:queue_item, user: user, position: 1)
        video_queue_item1 = Fabricate(:queue_item, user: user, position: 2)
  
        post :update_queue, queue_items: [{id: video_queue_item.id, position: 3 }, {id: video_queue_item1.id, position: 1}]
        expect(video_queue_item1.reload.position).to eq(2)
      end
    end  
  end
end