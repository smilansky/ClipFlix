require 'spec_helper'

describe StripeWrapper::Customer do
  describe ".create" do

    before do
      StripeWrapper.set_api_key
    end

    let(:token) do
    Stripe::Token.create(
        :card => {
        :number => card_number,
        :exp_month => 8,
        :exp_year => 2020,
        :cvc => 314
      }
    ).id
    end

    context "with valid card", :vcr do
      let(:card_number) { '4242424242424242' }
      it "creates the customer successfully" do
        daniel = Fabricate(:user)
        response = StripeWrapper::Customer.create(card: token,
        user: daniel)
        response.should be_successful
      end

      it "returns the customer id" do
        daniel = Fabricate(:user)
        response = StripeWrapper::Customer.create(card: token,
        user: daniel)
        expect(response.customer_id).to be_present
      end
    end

    context "with invalid card", :vcr do
      let(:daniel) { Fabricate(:user) }
      let(:card_number) { '4000000000000002' }
      let(:response) { StripeWrapper::Customer.create(card: token,
        user: daniel) }

      it "does not create a customer", :vcr do
        response.should_not be_successful
      end

      it "contains an error message", :vcr do
        response.error_message.should == 'Your card was declined.'
      end
    end
  end
end