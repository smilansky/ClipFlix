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

    describe "search_by_title" do
      
      context "all" do
        let(:com) { Video.create(title: 'Futures', description: 'awesome') }
        let(:futurama) { Video.create(title: 'Futurama', description: 'great', created_at: 1.day.ago) }

        it "returns an empty array if there is no match" do
          expect(Video.search_by_title('Batman')).to eq([])
        end 

        it "returns an array of one video for an exact match" do
          expect(Video.search_by_title('Futurama')).to eq([futurama])
        end

        it "returns an array of one video for a partial match" do
          expect(Video.search_by_title('Fu')).to eq([futurama])
        end

        it "returns an array of all matches" do
          expect(Video.search_by_title('Fu')).to eq([com, futurama])
        end

        it "returns an empty array for a search with an empty string" do
          expect(Video.search_by_title("")).to eq([])
        end
      end
    end
end
