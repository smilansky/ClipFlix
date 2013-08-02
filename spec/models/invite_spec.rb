require 'spec_helper'

describe Invite do
  it { should belong_to(:user) }

  it "generates a random token" do
    invite = Fabricate(:invite)
    expect(invite.token).to be_present
  end
end