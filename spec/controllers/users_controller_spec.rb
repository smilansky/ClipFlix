require 'spec_helper'

describe UsersController do
  describe "GET new" do
    context "without token" do
      it "sets @user to a new user if not logged in" do
        get :new
        expect(assigns(:user)).to be_a_new(User)
      end  
    end

    context "with token" do
      it "sets @invite" do
        invite = Fabricate(:invite, email: "email@example.com", name: "mike", token: '54321')
        get :new, format: invite.token
        expect(assigns[:invite]).to eq(invite)
      end

      it "sets @user with parameters from the corresponding invite token" do
        invite = Fabricate(:invite, email: "email@example.com", name: "mike", token: '54321')
        get :new, format: invite.token
        expect(assigns(:user).email).to eq('email@example.com')
      end
    end
  end

  describe "POST create" do
    context "with valid parameters" do
      it "saves the user in the database" do
        post :create, user: { fullname: "Bob", email: "bob@bob.com", password: "bob" } 
        User.first.fullname.should == "Bob"
        User.first.email.should == "bob@bob.com"
      end

      it "redirects to the home_path" do
        post :create, user: { fullname: "Bob", email: "bob@bob.com", password: "bob" } 
        expect(response).to redirect_to home_path
      end

      context "with token" do      
        it "creates a leader relationship with the user that invited" do
          daniel = Fabricate(:user)
          invite = Fabricate(:invite, email: "email@example.com", name: "mike", token: '54321', user_id: daniel.id)
          
          post :create, user: { fullname: "Bob", email: "bob@bob.com", password: "bob" }, invite_user_id: daniel.id
          expect(Relationship.first.leader_id).to eq(2)
        end
        
        it "created a following relationship with the user that invited" do
          daniel = Fabricate(:user)
          invite = Fabricate(:invite, email: "email@example.com", name: "mike", token: '54321', user_id: daniel.id)
          
          post :create, user: { fullname: "Bob", email: "bob@bob.com", password: "bob" }, invite_user_id: daniel.id
          expect(Relationship.where(id: 2).first.leader_id).to eq(1)
        end
      end
    end  

    context "email sending" do
      after { ActionMailer::Base.deliveries.clear }
      it "sends out the email with valid inputs" do
        post :create, user: { fullname: "Bob", email: "bob@bob.com", password: "bob" }
        ActionMailer::Base.deliveries.should_not be_empty
      end
      it "sends to the right recipient" do
        post :create, user: { fullname: "Bob", email: "bob@bob.com", password: "bob" }
        message = ActionMailer::Base.deliveries.last
        message.to.should == [User.first.email]
      end
      it "has the right content" do
        post :create, user: { fullname: "Bob", email: "bob@bob.com", password: "bob" }
        message = ActionMailer::Base.deliveries.last
        message.body.should include('Welcome to MyFlix')
      end

      it "does not send out email with invalid inputs" do
        post :create, user: { email: "bob@bob.com", password: "bob" }
        ActionMailer::Base.deliveries.should be_empty
      end

    end
    
    context "with invalid parameters" do
    before {  post :create, user: { fullname: "Bob", email: "bob@bob.com" } }
      it "does not save the new message in the database" do
        expect(User.count).to eq(0)
      end
      
      it "renders the new template" do
        expect(response).to render_template :new
      end
      
      it "sets the @user variable" do
        expect(assigns(:user)).to be_a_new(User)
      end
    end
  end 

  describe "GET show" do 

    it_behaves_like "require_sign_in" do
      let(:action) { get :show, id: 4}
    end

    it "assigns @user" do
      set_current_user
      daniel = Fabricate(:user)
      get :show, id: daniel.id

      expect(assigns(:user)).to eq(daniel)
    end
    
    it "renders the correct correct user's profile page" do
      set_current_user
      daniel = Fabricate(:user)
      get :show, id: daniel.id

      expect(response).to render_template daniel
    end
  end
end