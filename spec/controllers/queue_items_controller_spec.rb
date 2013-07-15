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
end