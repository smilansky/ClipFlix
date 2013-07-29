require 'spec_helper'

describe PasswordResetsController do
  describe "GET show" do
    it "renders show template if the token is valid" do
      daniel = Fabricate(:user)
      daniel.update_column(:token, '12345')
      get :show, id: '12345'
      expect(response).to render_template :show
    end
    it "redirects to the expired token page if hte token is not valid" do
      get :show, id: '12345'
      expect(response).to redirect_to expired_token_path
    end

    it "sets @token" do
      daniel = Fabricate(:user)
      daniel.update_column(:token, '12345')
      get :show, id: '12345'
      expect(assigns[:token]).to eq('12345')
    end
  end

  describe "POST create" do
    context "valid token" do
      it "redirects to the sign in page" do
        daniel = Fabricate(:user, password: 'old_password')
        daniel.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        expect(response).to redirect_to sign_in_path
      end

      it "should update the user's password" do
        daniel = Fabricate(:user, password: 'old_password')
        daniel.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        expect(daniel.reload.authenticate('new_password')).to be_true
      end

      it "sets the flash success message" do
        daniel = Fabricate(:user, password: 'old_password')
        daniel.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        expect(flash[:success]).to be_present
      end
      it "regenerates the user's token" do
        daniel = Fabricate(:user, password: 'old_password')
        daniel.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        expect(daniel.reload.token).not_to eq('12345')
      end
    end
    context "invalid token" do
      it "redirects to the expired token path" do
        post :create, token: '12345', password: 'new_password'
        expect(response).to redirect_to expired_token_path
      end

    end

  end
end