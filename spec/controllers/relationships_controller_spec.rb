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


end