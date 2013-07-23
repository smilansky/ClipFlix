require 'spec_helper'

feature 'My_queue' do
  scenario 'user can reorder videos in my_queue' do
    
    movies = Fabricate(:category) 
    xmen = Fabricate(:video, title: 'Xmen', category: movies)
    futurama = Fabricate(:video, title: 'Futurama', category: movies )
    monk = Fabricate(:video, title: 'Monk', category: movies)

    daniel = Fabricate(:user)
    visit sign_in_path
    fill_in "email", with: daniel.email
    fill_in "password", with: daniel.password
    click_button "Sign in"
    page.should have_content daniel.fullname
    
    find("a[href='/videos/#{xmen.id}']").click
    page.should have_content(xmen.title)

    click_button "+ My Queue"
    page.should have_content(xmen.title)
    
    find("a[href='/videos/#{xmen.id}']").click
    page.should_not have_content('+ My Queue')

    find("a[href='/home']").click
    
    find("a[href='/videos/#{futurama.id}']").click
    click_button "+ My Queue"
    page.should have_content(futurama.title)
    
    find("a[href='/home']").click
    find("a[href='/videos/#{monk.id}']").click
    click_button "+ My Queue"
    page.should have_content(monk.title)
   
    fill_in "queue_item_2", :with => 4
    fill_in "queue_item_1", :with => 5
    click_button "Update Instant Queue"

    find_field("queue_item_1").value.should eq("3")
    find_field("queue_item_2").value.should eq("2")
    find_field("queue_item_3").value.should eq("1")
  end

end
