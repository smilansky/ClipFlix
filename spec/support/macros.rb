def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
  daniel = Fabricate(:user)
end

def set_current_admin(user=nil)
  session[:user_id] = (user || Fabricate(:user, admin: true)).id
end

def current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

def sign_in(a_user=nil)
  user = a_user || Fabricate(:user)
  visit sign_in_path
  fill_in "email", with: user.email
  fill_in "password", with: user.password
  click_button "Sign in"
end

def admin_sign_in(a_admin=nil)
  admin = a_admin || Fabricate(:user, admin: true)
  visit sign_in_path
  fill_in "email", with: admin.email
  fill_in "password", with: admin.password
  click_button "Sign in"
end

def last_email
  ActionMailer::Base.deliveries.last
end

def sign_out
  visit sign_out_path
end