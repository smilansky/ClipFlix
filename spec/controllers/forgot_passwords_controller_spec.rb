require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "blank email" do
      it "redirects to the forgot password page" do
        post :create, email: ''

        expect(response).to redirect_to forgot_password_path
      end
      it "shows an error message" do
        post :create, email: ''
        expect(flash[:error]).to eq("Email cannot be blank")
      end
    end
    context "with existing email" do
      it "should redirect to the forgot password confirmation page" do
        Fabricate(:user, email: "daniel@example.com")
        post :create, email: "daniel@example.com"
        expect(response).to redirect_to forgot_password_confirmation_path
      end
      it "should send out an email to the email address" do
        Fabricate(:user, email: "daniel@example.com")
        post :create, email: "daniel@example.com"
        expect(ActionMailer::Base.deliveries.last.to).to eq(['daniel@example.com'])
      end
    end
    context "with non-existing email" do
      it "redirects to the forgot password page" do
        post :create, email: "daniel@example.com"
        expect(response).to redirect_to forgot_password_path
      end
      it "shows an error message" do
        post :create, email: "daniel@example.com"
        expect(flash[:error]).to eq("No user exists with this email address")
      end
    end

  end

end