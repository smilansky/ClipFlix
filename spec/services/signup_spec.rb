require 'spec_helper'

describe Signup do
  describe "#register_user" do
    context "valid personal info and valid card" do
      let(:customer) { double(:customer, successful?: true, customer_id: 'cus2232') }
      before { StripeWrapper::Customer.should_receive(:create).and_return(customer) }
      after { ActionMailer::Base.deliveries.clear }
      
      it "saves the customer_id from stripe" do
        daniel = Fabricate.build(:user)
        Signup.new(daniel).register_user('123', nil)
        expect(User.first.customer_id).to eq('cus2232')
      end

      it "saves the user in the database" do
        Signup.new(Fabricate.build(:user)).register_user('123', nil)
        expect(User.count).to eq(1)
      end

      it "has the user follow the user that invited" do
        daniel = Fabricate(:user)
        invite = Fabricate(:invite, email: "bob@bob.com", name: "mike", message: "message", token: '54321', user_id: daniel.id)
        
        Signup.new(Fabricate.build(:user)).register_user('123', invite.token)
        expect(Relationship.first.leader_id).to eq(1)
      end
      
      it "created a following relationship with the user that invited" do
        daniel = Fabricate(:user)
        invite = Fabricate(:invite, email: "bob@bob.com", name: "mike", message: "message", user_id: daniel.id)
        
        Signup.new(Fabricate.build(:user)).register_user('123', invite.token)
        expect(Relationship.where(id: 2).first.leader_id).to eq(2)
      end

      it "expires the invite upon acceptance" do
        daniel = Fabricate(:user)
        invite = Fabricate(:invite, email: "bob@bob.com", name: "mike", message: "message", user_id: daniel.id)
        
        Signup.new(Fabricate.build(:user)).register_user('123', invite.token)
        expect(Invite.first.token).to be_nil
      end

      it "sends out the email with valid inputs" do
        Signup.new(Fabricate.build(:user)).register_user('123', nil)
        ActionMailer::Base.deliveries.should_not be_empty
      end

      it "sends to the right recipient" do
        Signup.new(Fabricate.build(:user)).register_user('123', nil)
        message = ActionMailer::Base.deliveries.last
        message.to.should == [User.first.email]
      end

      it "has the right content" do
        Signup.new(Fabricate.build(:user)).register_user('123', nil)
        message = ActionMailer::Base.deliveries.last
        message.body.should include('Welcome to MyFlix')
      end
    end

    context "valid personal info and declined card" do
      it "does not create a new user record" do
        customer = double(:customer, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        Signup.new(Fabricate.build(:user)).register_user('123', nil)
        expect(User.count).to eq(0)
      end
    end

    context "with invalid personal info" do
      before { Signup.new(User.new(email: 'joe@example.com ')).register_user('123', '423')}
      after { ActionMailer::Base.deliveries.clear }
      it "does not save the new message in the database" do
        expect(User.count).to eq(0)
      end
      
      it "does not charge the card" do
        StripeWrapper::Customer.should_not_receive(:create)
      end

      it "does not send out email with invalid inputs" do
        ActionMailer::Base.deliveries.should be_empty
      end
    end
  end

end