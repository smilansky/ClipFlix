require 'spec_helper'

describe QueueItem do
    it { should belong_to(:user)}
    it { should belong_to(:video)}
    it { should validate_numericality_of(:position).only_integer }

    describe "#video_title" do
      it "should return the queue item video's title" do
        video = Fabricate(:video, title: 'Futurama')
        queue_item1 = Fabricate(:queue_item, video: video )
        expect(queue_item1.video_title).to eq('Futurama')
      end
    end

    describe "#rating" do
      it "should return the user's rating associated with the queue item's video" do
        video = Fabricate(:video)
        daniel = Fabricate(:user)
        review = Fabricate(:review, video: video, user: daniel, rating: 4)
        queue_item = Fabricate(:queue_item, video: video, user: daniel)

        expect(queue_item.rating).to eq(4)
      end 

      it "should return nil when the review is not present" do
        video = Fabricate(:video)
        daniel = Fabricate(:user)
        queue_item = Fabricate(:queue_item, video: video, user: daniel)

        expect(queue_item.rating).to eq(nil)
      end
    end

    describe "#category_name" do
      it "should return the queue item video's category name" do
        category = Fabricate(:category)
        video = Fabricate(:video, title: 'Futurama', category: category)
        queue_item1 = Fabricate(:queue_item, video: video )
        expect(queue_item1.category_name).to eq(category.name)
      end  
    end


  describe "#rating=" do
        it "updates the rating for the queue_item video review" do
        current_user = Fabricate(:user)
        video = Fabricate(:video)
        review = Review.create( content: "blah blach", rating: 1, user_id: current_user.id, video_id: video.id)
        video_queue_item = Fabricate(:queue_item, video: video, user: current_user, position: 4)
  
        video_queue_item.rating = 2
        expect(Review.first.rating).to eq(2)
      end

      it "clears the rating of a review if the review is present" do
        current_user = Fabricate(:user)
        video = Fabricate(:video)
        review = Review.create( content: "blah blach", rating: 1, user_id: current_user.id, video_id: video.id)
        video_queue_item = Fabricate(:queue_item, video: video, user: current_user, position: 4)
  
        video_queue_item.rating = nil
        expect(Review.first.rating).to be_nil     
      end

      it "creates a new rating for a queue_item video that has no review" do
        current_user = Fabricate(:user)
        video = Fabricate(:video)
        review = Review.create( content: "blah blach", user_id: current_user.id, video_id: video.id)
        video_queue_item = Fabricate(:queue_item, video: video, user: current_user, position: 4)
  
        video_queue_item.rating = 1
        expect(Review.first.rating).to eq(1) 
      end
  end

end