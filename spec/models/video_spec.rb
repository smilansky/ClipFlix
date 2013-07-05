require 'spec_helper'

describe Video do
  it "saves itself" do
    video = Video.new(title: 'Family Guy', description: 'American adult animated sitcom.', small_cover_url: '/tmp/family_guy.jpg')
    video.save
    Video.first.should == video
  end

  it { should belong_to(:category)}
  it { validate_presence_of(:title)}
  it { validate_presence_of(:description)}
  it "is valid with a title and description" do
    video = Video.new(title: 'Dexter', description: 'Adult HBO drama following a Miami homicide detective and blood pattern specialist, Dexter Morgan')
    expect(video).to be_valid
  end
end