require 'spec_helper'

describe User do  
  it "saves itself" do 
    user = User.new(fullname: "Buzz Killington", password: "pass", email: "email@email.com")
    user.save

    expect(User.first).to eq(user)
  end
end