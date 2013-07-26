require 'spec_helper'

describe RelationshipsController do

  describe "GET index" do
    it "sets @relationships to the current user's following relationships" do
      set_current_user
      mike = Fabricate(:user)
      relationship = Fabricate(:relationship, user_id: current_user.id, leader_id: mike.id)
      get :index

      expect(assigns(:relationships)).to eq([relationship])
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    it_behaves_like "require_sign_in" do
      let(:action) { post :create, leader_id: 2}
    end

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

      expect(current_user.following_relationships.first.leader).to eq(mike)
    end

    it "does not create a duplicate relationship" do
      set_current_user
      mike = Fabricate(:user)
      Relationship.create(user_id: current_user.id, leader_id: mike.id)
      post :create, leader_id: mike.id

      expect(Relationship.count).to eq(1)
    end

    it "does not allow a user to follow himself" do
      set_current_user
      post :create, leader_id: current_user.id

      expect(Relationship.count).to eq(0)
    end

  end

  describe "DELETE destroy" do
      it_behaves_like "require_sign_in" do
        let(:action) { delete :destroy, id: 1 }
      end
      it "redirects to the people page" do
        set_current_user
        mike = Fabricate(:user)
        relationship = Relationship.create(user_id: current_user.id, leader_id: mike.id)

        delete :destroy, id: relationship
        expect(response).to redirect_to people_path
      end

      it "deletes the relationship if the current user is the follower" do
        set_current_user
        mike = Fabricate(:user)
        relationship = Relationship.create(user_id: current_user.id, leader_id: mike.id)
        delete :destroy, id: relationship

        expect(Relationship.count).to eq(0)
      end

      # it "does not delete the relationship if the current user is not the follower" do
      #   set_current_user
      #   daniel = Fabricate(:user)
      #   mike = Fabricate(:user)
      #   relationship = Relationship.create(user_id: daniel.id, leader_id: mike.id)
      #   delete :destroy, id: relationship

      #   expect(Relationship.count).to eq(1)
      # end
  end

end