require 'spec_helper'

describe Category do
  it "saves itself" do
    category = Category.new(name: "Mysteries")
    category.save
    Category.first.should == category
  end

  it { should have_many(:videos)}

  describe "#recent_videos" do
    it "returns an empty array if the category has no videos" do
      mys = Category.create(name: "Mysteries")
      expect(mys.recent_videos).to eq([])
    end
    it "returns the videos in the reverse chronical order by created at" do
      mys = Category.create(name: "Mysteries")
      shutis = Video.create(title: "Shutter Island", description: "mystery", category: mys, created_at: 1.hours.ago)
      muldr = Video.create(title: "Mulholland Drive", description: "mystery", category: mys, created_at: 4.hours.ago)
      incep = Video.create(title: "Inception", description: "mystery", category: mys, created_at: 3.hours.ago)
      seven = Video.create(title: "Seven", description: "mystery", category: mys, created_at: 2.hours.ago)

      expect(mys.recent_videos).to eq([shutis,seven,incep,muldr])
    end

    it "returns an array with all of the videos if the category has less than six videos" do
      mys = Category.create(name: "Mysteries")
      shutis = Video.create(title: "Shutter Island", description: "mystery", category: mys, created_at: 1.hours.ago)
      muldr = Video.create(title: "Mulholland Drive", description: "mystery", category: mys, created_at: 4.hours.ago)
      incep = Video.create(title: "Inception", description: "mystery", category: mys, created_at: 3.hours.ago)
      seven = Video.create(title: "Seven", description: "mystery", category: mys, created_at: 2.hours.ago)

      expect(mys.recent_videos.count).to eq(4)    
    end

    it "returns 6 videos if there are more than 6 videos" do
      mys = Category.create(name: "Mysteries")
      shutis = Video.create(title: "Shutter Island", description: "mystery", category: mys, created_at: 1.hours.ago)
      muldr = Video.create(title: "Mulholland Drive", description: "mystery", category: mys, created_at: 4.hours.ago)
      incep = Video.create(title: "Inception", description: "mystery", category: mys, created_at: 3.hours.ago)
      seven = Video.create(title: "Seven", description: "mystery", category: mys, created_at: 2.hours.ago)
      ususus = Video.create(title: "The Usual Suspects", description: "mystery", category: mys, created_at: 30.minutes.ago)
      chin = Video.create(title: "Chinatown", description: "mystery", category: mys, created_at: 45.minutes.ago)
      citk = Video.create(title: "Citizen Kane", description: "mystery", category: mys, created_at: 15.minutes.ago)
      riv = Video.create(title: "Mystic River", description: "mystery", category: mys, created_at: 10.minutes.ago)

      expect(mys.recent_videos.count).to eq(6)
    end

    it "returns an array of the most recent six videos if the category has more than six videos" do
      mys = Category.create(name: "Mysteries")
      shutis = Video.create(title: "Shutter Island", description: "mystery", category: mys, created_at: 1.hours.ago)
      muldr = Video.create(title: "Mulholland Drive", description: "mystery", category: mys, created_at: 4.hours.ago)
      incep = Video.create(title: "Inception", description: "mystery", category: mys, created_at: 3.hours.ago)
      seven = Video.create(title: "Seven", description: "mystery", category: mys, created_at: 2.hours.ago)
      ususus = Video.create(title: "The Usual Suspects", description: "mystery", category: mys, created_at: 30.minutes.ago)
      chin = Video.create(title: "Chinatown", description: "mystery", category: mys, created_at: 45.minutes.ago)
      citk = Video.create(title: "Citizen Kane", description: "mystery", category: mys, created_at: 15.minutes.ago)
      riv = Video.create(title: "Mystic River", description: "mystery", category: mys, created_at: 10.minutes.ago)

      expect(mys.recent_videos).not_to include([muldr, incep])
    end
  end
end