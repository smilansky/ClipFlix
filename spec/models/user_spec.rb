require 'spec_helper'

describe User do  
  it "saves itself" do 
    user = User.new(fullname: "Buzz Killington", password: "pass", email: "email@email.com")
    user.save

    expect(User.first).to eq(user)
  end

it { should validate_presence_of(:email)}
it { should validate_presence_of(:password)}
it { should validate_presence_of(:fullname)}
it { should validate_uniqueness_of(:email)}
it { should have_many(:queue_items).order(:order)}
end