require 'spec_helper'

describe InvitesController do

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
    
    context "with valid parameters" do
      after { ActionMailer::Base.deliveries.clear }
      it "should redirect to the home page" do
        post :create, invite: { email: 'email@example.com', name: 'jason', message: 'sign up' }
        expect(response).to redirect_to home_path
      end
      
      it "should create an invite" do
        post :create, invite: { email: 'email@example.com', name: 'jason', message: 'sign up' }
        expect(Invite.count).to eq(1)
      end

      it "sends out an email to the email address" do
        post :create, invite: { email: 'email@example.com', name: 'jason', message: 'sign up' }
        expect(ActionMailer::Base.deliveries.last.to).to eq(["email@example.com"])
      end

      it "sets the success message" do
        post :create, invite: { email: 'email@example.com', name: 'jason', message: 'sign up' }
        expect(flash[:success]).to be_present        
      end
    end



    context "with invalid parameters" do
      after { ActionMailer::Base.deliveries.clear }
      it "renders to the invite new template" do
        post :create, invite: { email: ' ', name: 'jason', message: 'sign up' }
        expect(response).to render_template :new
      end

      it "does not create an invitation" do
        post :create, invite: { email: ' ', name: 'jason', message: 'sign up' }
        expect(Invite.count).to eq(0)
      end

      it "does not send out an email" do
        post :create, invite: { email: ' ', name: 'jason', message: 'sign up' }
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "sets flash error message" do
        post :create, invite: { email: ' ', name: 'jason', message: 'sign up' }
        expect(flash[:error]).to be_present     
      end
     
      it "sets @invite" do
        post :create, invite: { email: ' ', name: 'jason', message: 'sign up' } 
        expect(assigns(:invite)).to be_present        
      end
    end

    context "with existing email" do
      it "redirects to the invite path" do
        mike = Fabricate(:user, email: 'email@example.com')
        post :create, invite: { email: 'email@example.com', name: 'jason', message: 'sign up' }
        expect(response).to redirect_to invite_path
      end

      it "displays an error message" do
        mike = Fabricate(:user, email: 'email@example.com')
        post :create, invite: { email: 'email@example.com', name: 'jason', message: 'sign up' }
        expect(flash[:error]).to be_present
      end
    end   
  end
end