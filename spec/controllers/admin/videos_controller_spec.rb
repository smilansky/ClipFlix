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

  describe "POST create" do
    it_behaves_like "require_sign_in" do
      let(:action) { post :create }
    end

    it "redirects a regular user to the home page" do
      set_current_user
      post :create
      expect(response).to redirect_to home_path
    end

    it "sets the flash error message for a regular user" do
      set_current_user
      post :create
      expect(flash[:error]).to be_present
    end

    context "valid parameters" do
      it "redirects to the add video page" do
        set_current_admin
        post :create, video: Fabricate.attributes_for(:video)

        expect(response).to redirect_to admin_add_video_path
      end

      it "creates a video" do
        set_current_admin
        post :create, video: Fabricate.attributes_for(:video)

        expect(Video.count).to eq(1)
      end

      it "sets the flash success message" do
        set_current_admin
        post :create, video: Fabricate.attributes_for(:video)

        expect(flash[:success]).to be_present
      end
    end

    context "invalid parameters" do
      it "renders the new template" do
        set_current_admin
        post :create, video: { title: "" }

        expect(response).to render_template :new
      end

      it "does not create a video" do
        set_current_admin
        post :create, video: { title: "" }

        expect(Video.count).to eq(0)
      end

      it "sets @video" do
        set_current_admin
        post :create, video: { title: "" }

        expect(assigns(:video)).to be_a_new(Video)
      end

      it "sets the flash error message" do
        set_current_admin
        post :create, video: { title: "" }

        expect(flash[:error]).to be_present
      end    
    end
  end
end