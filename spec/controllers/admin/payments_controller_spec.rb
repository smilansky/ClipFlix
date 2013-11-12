require 'spec_helper'

describe Admin::PaymentsController do
  describe "GET index" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :index }
    end

    it "redirects to the home path for non admins" do
      set_current_user
      get :index

      expect(response).to redirect_to home_path
    end

    it "sets @payments for admins" do
      payment = Fabricate(:payment)
      set_current_admin
      get :index

      expect(assigns(:payments)).to eq([payment])
    end
  end
end