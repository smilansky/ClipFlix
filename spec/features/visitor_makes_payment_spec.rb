require 'spec_helper'

feature 'Visitor makes payment', js: true do
  background do
    visit register_path
  end

  scenario "with valid user input and valid card number", :vcr do
    fill_in_valid_user_info
    fill_in_credit_card('4242424242424242')
    click_button "Sign Up"
    expect(page).to have_content "Thank you for your generous payment. Welcome to MyFlix!"
  end

  scenario "with valid user input and invalid card number", :vcr do
    fill_in_valid_user_info
    fill_in_credit_card('4000000000000069')
    click_button "Sign Up"
    expect(page).to have_content "Your card's expiration date is incorrect"
  end

  scenario "with invalid user input and valid card number", :vcr do
    fill_in_invalid_user_info
    fill_in_credit_card('4242424242424242')
    click_button "Sign Up"
    expect(page).to have_content "can't be blank"

  end

  scenario "with invalid user input and invalid card number" do
    fill_in_invalid_user_info
    fill_in_credit_card('4000000000000069')
    click_button "Sign Up"
    expect(page).to have_content "can't be blank"
  end

  scenario "valid user input and declined card", :vcr do
    fill_in_valid_user_info
    fill_in_credit_card('4000000000000002')
    click_button "Sign Up"
    expect(page).to have_content "Your card was declined"
  end
end

def fill_in_valid_user_info
    fill_in "Email Address", with: "example@example.com"
    fill_in "Password", with: "pass"
    fill_in "Full Name", with: "Bob Smith"
end

def fill_in_invalid_user_info
  fill_in "Email Address", with: ""
  fill_in "Password", with: "pass"
  fill_in "Full Name", with: "Bob Smith"
end

def fill_in_credit_card(card_number)
    fill_in "Credit Card Number", with: card_number
    fill_in "Security Code", with: "123"
    select "3 - March", from: 'date_month'
    select "2014", from: 'date_year'
end