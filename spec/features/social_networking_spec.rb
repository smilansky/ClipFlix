require 'spec_helper'

feature 'Social Networking' do
  scenario 'current user can follow another user', :vcr do
    movies = Fabricate(:category) 
    mike = Fabricate(:user)
    xmen = Fabricate(:video, title: 'xmen', description: 'great action thriller', category: movies, video_url: "vimeo.com/343")
    review = Fabricate(:review, user_id: mike.id, video_id: xmen.id)
    
    sign_in

    find("a[href='/videos/#{xmen.id}']").click
    page.should have_content(xmen.title)

    page.should have_content(mike.fullname)
    find("a[href='/users/#{mike.id}']").click
    page.should have_content(mike.fullname)
    click_link "Follow"

    page.should have_content(mike.fullname)
    find("a[href='/relationships/#{Relationship.first.id}']").click

    page.should_not have_content(mike.fullname)
  end

end