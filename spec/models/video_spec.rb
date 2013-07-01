require 'spec_helper'

describe Video do
  it "saves itself" do
    video = Video.new(title: 'Family Guy', description: 'American adult animated sitcom.', small_cover_url: '/tmp/family_guy.jpg')
    video.save
    Video.first.title.should == "Family Guy"
  end

  it "belongs to category" do
    video = Video.reflect_on_association(:category)
    video.macro.should == :belongs_to
  end
end