require 'spec_helper'

describe UsersController do
  describe "GET new" do
    context "without token" do
      it "sets @user to a new user if not logged in" do
        get :new
        expect(assigns(:user)).to be_a_new(User)
      end  
    end
  end

  describe "GET new_with_token" do
    context "with token" do

      it "renders the :new view template" do
        invite = Fabricate(:invite, email: "email@example.com", name: "mike", message: "message", token: '54321')
        get :new_with_token, token: invite.token
        expect(response).to render_template :new      
      end

      it "sets @user with parameters from the corresponding invite token" do
        invite = Fabricate(:invite, email: "email@example.com", name: "mike", message: "message", token: '54321')
        get :new_with_token, token: invite.token
        expect(assigns(:user).email).to eq('email@example.com')
      end

      it "redirects to expired token page for invalid tokens" do
        get :new_with_token, token: '12332'
        expect(response).to redirect_to expired_token_path    
      end

      it "sets @invite_token" do
        invite = Fabricate(:invite, email: "email@example.com", name: "mike", message: "message", token: '54321')
        get :new_with_token, token: invite.token
        expect(assigns(:invite_token)).to eq(invite.token)
      end
    end
  end

  describe "POST create" do
    context "successful user signs in" do
      it "redirects to the home_path" do
        result = double(:register_user_result, successful?: true)
        Signup.any_instance.should_receive(:register_user).and_return(result)
        post :create, user: { fullname: "Bob", email: "bob@bob.com", password: "bob" } 
        expect(response).to redirect_to home_path
      end
    end  

    context "unsuccessful user signs in" do
      it "renders the new page" do
        result = double(:register_user_result, successful?: false, error_message: "This is an error message")
        Signup.any_instance.should_receive(:register_user).and_return(result)
        post :create, user: { fullname: "Bob", email: "bob@bob.com", password: "bob" }, stripeToken: '123123' 
        expect(response).to render_template :new     
      end

      it "sets the flash error message" do
        result = double(:register_user_result, successful?: false, error_message: "This is an error message")
        Signup.any_instance.should_receive(:register_user).and_return(result)
        post :create, user: { fullname: "Bob", email: "bob@bob.com", password: "bob" }, stripeToken: '123234'
        expect(flash[:error]).to be_present
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