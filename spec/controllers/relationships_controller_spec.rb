require 'spec_helper'

describe RelationshipsController do

  describe "GET index" do
    it "sets @leaders" do
      set_current_user
      mike = Fabricate(:user)
      relationship = Fabricate(:relationship, user_id: current_user.id, leader_id: mike.id)
      get :index

      expect(assigns(:leaders)).to eq([mike])
    end
  end

  describe "POST create" do
    context "authenticated user" do
      it "redirects to the people page" do
        set_current_user
        mike = Fabricate(:user)
        post :create, leader_id: mike.id

        expect(response).to redirect_to people_path
      end
      
      it "creates a relationship" do
        set_current_user
        mike = Fabricate(:user)
        post :create, leader_id: mike.id

        expect(Relationship.count).to eq(1)
      end
      
    end

    context "unauthenticated user" do  
      it "redirects to the root path"
    end
    

  end

end