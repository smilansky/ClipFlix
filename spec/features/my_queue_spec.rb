require 'spec_helper'

feature 'My_queue' do
  scenario 'user can reorder videos in my_queue', :vcr do
    
    movies = Fabricate(:category) 
    xmen = Fabricate(:video, title: 'Xmen', category: movies, video_url: "vimeo.com/343")
    futurama = Fabricate(:video, title: 'Futurama', category: movies, video_url: "vimeo.com/343" )
    monk = Fabricate(:video, title: 'Monk', category: movies, video_url: "vimeo.com/343")

    sign_in

    find("a[href='/videos/#{xmen.id}']").click
    page.should have_content(xmen.title)

    click_link "+ My Queue"
    page.should have_content(xmen.title)
    
    find("a[href='/videos/#{xmen.id}']").click
    page.should_not have_content('+ My Queue')

    visit home_path 
    
    find("a[href='/videos/#{futurama.id}']").click
    click_link "+ My Queue"
    page.should have_content(futurama.title)
    
    visit home_path
    find("a[href='/videos/#{monk.id}']").click
    click_link "+ My Queue"
    page.should have_content(monk.title)
   
    fill_in "queue_item_2", :with => 4
    fill_in "queue_item_1", :with => 5
    click_button "Update Instant Queue"

    find_field("queue_item_1").value.should eq("3")
    find_field("queue_item_2").value.should eq("2")
    find_field("queue_item_3").value.should eq("1")
  end

end
