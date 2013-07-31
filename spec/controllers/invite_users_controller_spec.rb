require 'spec_helper'

describe InviteUsersController do
  describe "POST create" do
    context "with blank email" do
      it "redirects to the invite path" do
        post :create, friends_email: ''
        expect(response).to redirect_to invite_path
      end
      it "displays an error message" do
        post :create, friends_email: ''
        expect(flash[:error]).to be_present
      end
    end
    context "non existing email" do
      it "should redirect to the home page" do
        post :create, friends_email: 'email@example.com'
        expect(response).to redirect_to home_path
      end
      it "should send out an email to the email address" do
      end
    end
    context "with existing email" do
      it "redirects to the invite path"
    end   
  end
end