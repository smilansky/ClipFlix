require 'spec_helper'

feature 'Admin Add Video' do
  scenario 'Admin can add a video and a non-admin user can watch it', :vcr do
    Category.create(name: "Action Movies")
    admin_sign_in

    fill_in "Title", with: "Xmen"
    select "Action Movies", from: "video[category_id]"
    fill_in "Description", with: "Great Movie"
    attach_file "Large cover", "spec/support/uploads/large_cover_test.jpeg"
    attach_file "Small cover", "spec/support/uploads/small_cover_test.jpeg"
    fill_in "Video URL", with: "http://www.vimeo.com/343"
    click_button "Add Video"

    sign_out
    sign_in
    
    visit video_path(Video.first)
    expect(page).to have_selector("a[href='http://www.vimeo.com/343']")
  end  
end