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

end