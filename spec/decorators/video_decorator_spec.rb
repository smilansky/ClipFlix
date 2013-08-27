require 'spec_helper'

describe VideoDecorator do
  describe "#rating" do
    it "returns nil if there are no ratings" do
      video = Fabricate(:video)

      expect(VideoDecorator.new(video).rating).to eq(nil)
    end
    it "returns the average rating" do
      video = Fabricate(:video)
      user = Fabricate(:user)

      Review.create(user_id: user.id, video_id: video.id, rating: 3, content: "awesome")
      Review.create(user_id: user.id, video_id: video.id, rating: 5, content: "awesome")
      Review.create(user_id: user.id, video_id: video.id, rating: 4, content: "awesome")

      expect(VideoDecorator.new(video).rating).to eq(4)
    end
    it "rounds the average rating up" do
      video = Fabricate(:video)
      user = Fabricate(:user)

      Review.create(user_id: user.id, video_id: video.id, rating: 0, content: "awesome")
      Review.create(user_id: user.id, video_id: video.id, rating: 1, content: "awesome")

      expect(VideoDecorator.new(video).rating).to eq(1)
    end
  end

  describe "#rating_show" do
    it "returns N/A if there is no rating" do
      video = Fabricate(:video)

      expect(VideoDecorator.new(video).rating_show).to eq("N/A")
    end
    
    it "returns average rating/5.0 if there is a rating" do
      video = Fabricate(:video)
      user = Fabricate(:user)

      Review.create(user_id: user.id, video_id: video.id, rating: 3, content: "awesome")
      Review.create(user_id: user.id, video_id: video.id, rating: 5, content: "awesome")
      Review.create(user_id: user.id, video_id: video.id, rating: 4, content: "awesome")

      expect(VideoDecorator.new(video).rating_show).to eq("4/5.0")
    end
  end
end