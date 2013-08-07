require 'spec_helper'

feature 'Reset Password' do
  background do
    clear_emails
  end
  
  scenario 'user can reset their password' do
    daniel = Fabricate(:user, email: 'test@example.com', password: "old_pass")
    sign_in(daniel)

    visit(forgot_password_path)


    fill_in "email", with: daniel.email
    click_button "Send Email"

    open_email('test@example.com')
    current_email.body.should include(daniel.token)
    current_email.click_link "Reset Password Here"

    page.should have_content 'Reset Your Password'
    fill_in "password", with: "new_pass"

    click_button "Reset Password"
    fill_in "email", with: daniel.email
    fill_in "password", with: "new_pass"

    click_button "Sign in"
    page.should have_content daniel.fullname
    clear_emails
  end
end