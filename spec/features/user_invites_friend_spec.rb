require 'spec_helper'

feature 'User invites friend' do
  scenario 'User successfully invites friend and invitation is accepted' do
    daniel = Fabricate(:user)
    sign_in(daniel)

    invite_a_friend
    friend_accepts_invitation
    friend_signs_in

    friend_should_follow(daniel)

    sign_in(daniel)
    inviter_should_follow_friend(daniel)

    clear_email
  end

  def invite_a_friend
    visit invite_path
    fill_in "Friend's Name", with: "John Doe"
    fill_in "Friend's Email Address", with: "john@example.com"
    fill_in "Message", with: "Come join MyFLIX!"
    click_button "Send Invitation"
    sign_out
  end

  def friend_accepts_invitation
    open_email "john@example.com"
    current_email.click_link "Click Here To Join MyFLIX!"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "John Doe"
    click_button "Sign Up"
  end

  def friend_signs_in
    visit sign_in_path
    fill_in "Email", with: "john@example.com"
    fill_in "Password", with: "password"
    click_button "Sign in"
  end

  def friend_should_follow(user)
    click_link "People"
    expect(page).to have_content user.fullname
    sign_out
  end

  def inviter_should_follow_friend(user)
    click_link "People"
    expect(page).to have_content user.fullname
  end
end