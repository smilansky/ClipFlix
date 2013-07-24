require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user to a new user if not logged in" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end  

    it "redirects to the home path if logged in" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    context "with valid parameters" do
      before { post :create, user: { fullname: "Bob", email: "bob@bob.com", password: "bob" } }

      it "saves the user in the database with valid parameters" do
        User.first.fullname.should == "Bob"
        User.first.email.should == "bob@bob.com"
      end

      it "redirects to the home_path" do
        expect(response).to redirect_to home_path
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
    it "assigns @user" do
      daniel = Fabricate(:user)
      get :show, id: daniel.id

      expect(assigns(:user)).to eq(daniel)
    end
    
    it "renders the correct correct user's profile page" do
      daniel = Fabricate(:user)
      get :show, id: daniel.id

      expect(response).to render_template daniel
    end
  end
end