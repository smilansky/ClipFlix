require 'spec_helper'

feature 'User signs in' do
  background do
    User.create(fullname: "Daniel Smilansky", email: "dsmilansky@gmail.com", password: "daniel")
  end
  scenario "with existing email and password" do
    visit sign_in_path
    fill_in "email", with: "dsmilansky@gmail.com"
    fill_in "password", with: "daniel"
    click_button "Sign in"
    page.should have_content "Daniel Smilansky"
  end

  given(:other_user) { User.make(:email => 'other@example.com', :password => 'rous') }

  scenario "with a non existant email and password" do

    visit sign_in_path 
    fill_in "email", with: "other@example.com"
    fill_in "password", with: "rous"
    click_button "Sign in"
    page.should have_content "There is something wrong with your username or password"
  end
end