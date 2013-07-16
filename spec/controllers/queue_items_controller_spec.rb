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
        post :create, queue_item: Fabricate.attributes_for(:queue_item), video: video.id, user: current_user.id
      end
      it "redirects to the my_queue page" do
        expect(response).to redirect_to my_queue_path
      end

      it "creates a new queue item" do
        expect(QueueItem.count).to eq(1)
      end  

      it "creates a new queue item with the associated video" do
        expect(QueueItem.first.video).to eq(video)
      end

      it "create a new queue item with associated user" do
        expect(QueueItem.first.user).to eq(current_user)
      end
    end
  end
end