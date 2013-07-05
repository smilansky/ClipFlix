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

      it "returns an empty array if there is no match" do
        com = Video.create(title: 'Children of Men', description: 'Set in the 25th century, the story centers around a man and a woman who rebel against their rigidly controlled society.')
        futurama = Video.create(title: 'Futurama', description: 'American animated science fiction sitcom.')
        expect(Video.search_by_title('Batman')).to eq([])
      end 

      it "returns an array of one video for an exact match" do
        com = Video.create(title: 'Children of Men', description: 'Set in the 25th century, the story centers around a man and a woman who rebel against their rigidly controlled society.')
        futurama = Video.create(title: 'Futurama', description: 'American animated science fiction sitcom.')
        expect(Video.search_by_title('Futurama')).to eq([futurama])
      end

      it "returns an array of one video for a partial match" do
        com = Video.create(title: 'Children of Men', description: 'Set in the 25th century, the story centers around a man and a woman who rebel against their rigidly controlled society.')
        futurama = Video.create(title: 'Futurama', description: 'American animated science fiction sitcom.')
        expect(Video.search_by_title('Fu')).to eq([futurama])
      end

      it "returns an array of all matches" do
        fullh = Video.create(title: 'Full House', description: 'American sitcom television series.')
        futurama = Video.create(title: 'Futurama', description: 'American animated science fiction sitcom.', created_at: 1.day.ago)
        expect(Video.search_by_title('Fu')).to eq([fullh, futurama])
      end

      it "returns an empty array for a search with an empty string" do
        com = Video.create(title: 'Children of Men', description: 'Set in the 25th century, the story centers around a man and a woman who rebel against their rigidly controlled society.')
        futurama = Video.create(title: 'Futurama', description: 'American animated science fiction sitcom.')
        expect(Video.search_by_title("")).to eq([])
      end
    end
end
