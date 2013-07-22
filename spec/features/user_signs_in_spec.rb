require 'spec_helper'

feature 'User signs in' do
  background do
    User.create(fullname: "Daniel Smilansky", email: "dsmilansky@gmail.com", password: "daniel")
  end
  scenario "with existing username" do
    visit sign_in_path
    fill_in "email", with: "dsmilansky@gmail.com"
    fill_in "password", with: "daniel"
    click_button "Sign in"
    page.should have_content "Daniel Smilansky"
  end
end