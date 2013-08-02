require 'spec_helper'

describe InviteUsersController do

  describe "GET new" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end

    it "sets the invite variable" do
      daniel = Fabricate(:user)
      set_current_user(daniel)
      get :new

      expect(assigns(:invite)).to be_a_new(Invite)
    end
  end

  describe "POST create" do   
    it_behaves_like "require_sign_in" do
       let(:action) { post :create, friends_email: 'email@example.com' }
    end

    before do
      daniel = Fabricate(:user)
      set_current_user(daniel)
    end

    context "with blank email" do
      it "redirects to the invite path" do
        post :create, email: ''
        expect(response).to redirect_to invite_path
      end

      it "displays an error message" do
        post :create, email: ''
        expect(flash[:error]).to be_present
      end
    end

    context "non existing email" do
      it "should redirect to the home page" do
        post :create, email: 'email@example.com', user_id: current_user
        expect(response).to redirect_to home_path
      end

      it "should create an invite" do
        post :create, email: 'email@example.com', name: 'jason', message: 'sign up', user_id: current_user
        expect(Invite.count).to eq(1)
      end

      it "sends out an email to the email address" do
        post :create, email: 'email@example.com', user_id: current_user
        expect(ActionMailer::Base.deliveries.last.to).to eq(["email@example.com"])
      end
    end

    context "with existing email" do
      it "redirects to the invite path" do
        mike = Fabricate(:user, email: 'email@example.com')
        post :create, email: 'email@example.com', user_id: current_user
        expect(response).to redirect_to invite_path
      end

      it "displays an error message" do
        mike = Fabricate(:user, email: 'email@example.com')
        post :create, email: 'email@example.com', user_id: current_user
        expect(flash[:error]).to be_present
      end
    end   


  end
end