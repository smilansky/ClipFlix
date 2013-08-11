require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end

    it "sets @video" do
      daniel = Fabricate(:user, admin: true)
      set_current_admin
      get :new
      expect(assigns(:video)).to be_a_new(Video)
    end
    
    it "redirects a regular user to the home page" do
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end

    it "sets the flash error message for a regular user" do
      set_current_user
      get :new
      expect(flash[:error]).to be_present
    end
  end
end