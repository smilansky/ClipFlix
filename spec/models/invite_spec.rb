require 'spec_helper'

describe Invite do
  it { should belong_to(:user) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:message) }

  it "generates a random token" do
    invite = Fabricate(:invite, email: 'email@example.com', name: 'Daniel', message: 'message')
    expect(invite.token).to be_present
  end
end