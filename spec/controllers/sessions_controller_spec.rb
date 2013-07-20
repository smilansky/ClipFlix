require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "redirects to the user to the home path if user is authenticated" do
      set_current_user

      get :new
      expect(response).to redirect_to home_path
    end  
  end 

  describe "POST create" do 
    context "with valid credentials" do
      before :each do
        @bob = Fabricate(:user)
        post :create, email: @bob.email, password: @bob.password
      end

      it "sets the session id to the signed in user id" do
        expect(session[:user_id]).to eq(@bob.id)
      end  

      it "redirects the user to the home path" do
        expect(response).to redirect_to home_path
      end  

      it "sets the notice" do
        expect(flash[:notice]).not_to be_blank
      end
    end

    context "with invalid credentials" do
      before :each do
        bob = Fabricate(:user)
        post :create, email: bob.email, password: ""
      end
      
      it "does not set the session id" do
        expect(session[:user_id]).to eq(nil)
      end
      it "redirects the user to the sign in path" do
        expect(response).to redirect_to sign_in_path
      end 
      it "sets the notice" do
        expect(flash[:error]).not_to be_blank
      end  
    end
  end 

  describe "GET destroy" do 
    before :each do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end  
    it "sets the session user id to nil" do
      expect(session[:user_id]).to eq(nil)
    end

    it "redirects the user to the root path" do
      expect(response).to redirect_to root_path
    end

    it "sets the notice" do
      expect(flash[:notice]).not_to be_blank
    end
  end  
end  