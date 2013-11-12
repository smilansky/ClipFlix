require 'spec_helper'

feature 'User signs in' do
  scenario "with existing email and password" do
    daniel = Fabricate(:user, fullname: "Daniel Smilansky")
    sign_in(daniel)
    page.should have_content "Daniel Smilansky"
  end

  scenario "with a non existant email and password" do
    visit sign_in_path
    fill_in "email", with: "daniel@example.com"
    fill_in "password", with: "124kjf"
    click_button "Sign in"
    page.should have_content "There is something wrong with your username or password"
  end

  scenario "with deactivated user" do
    daniel = Fabricate(:user, active: false)
    sign_in(daniel)

    page.should_not have_content(daniel.fullname)
    page.should have_content("Your account has been suspended, please contact customer service.")
  end
end