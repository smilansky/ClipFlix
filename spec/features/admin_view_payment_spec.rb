require 'spec_helper'

feature 'Admin View Payment', js: true do
  background do
    daniel = Fabricate(:user, fullname: 'daniel')
    Fabricate(:payment, amount: 999, reference_id: '12345', user: daniel)
  end

  scenario 'Admin can view the payment', :vcr do
    admin_sign_in

    visit admin_view_payments_path
    page.should have_content "$9.99"
    page.should have_content "12345"
    page.should have_content "daniel"
  end

  scenario 'User cannot see the payment', :vcr do
    sign_in(Fabricate(:user))

    visit admin_view_payments_path
    page.should_not have_content "$9.99"
    page.should_not have_content "12345"
    page.should_not have_content "daniel"
  end
end
