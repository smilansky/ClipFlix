require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    let(:video) { Fabricate(:video) }
    context "authenticated user" do
      let(:current_user) { Fabricate(:user) }

      before do
        session[:user_id] = current_user.id
      end  
      context "valid parameters" do
        before { post :create, review: Fabricate.attributes_for(:review), video_id: video.id }
        it "redirects to the video show page" do
          expect(response).to redirect_to video
        end

        it "creates a review" do
          expect(Review.count).to eq(1)
        end

        it "creates a review associated with the video" do
          expect(Review.first.video).to eq(video)
        end

        it "creates a review associated with the signed in user" do          
          expect(Review.first.user_id).to eq(session[:user_id])
        end
      end

      context "invalid parameters" do  
        it "does not create a review" do
          post :create, review: Fabricate.attributes_for(:review, content: ""), video_id: video.id
          expect(Review.count).to eq(0)
        end

        it "renders the video show template" do
          post :create, review: Fabricate.attributes_for(:review, content: ""), video_id: video.id
          expect(response).to render_template "videos/show"
        end  

        it "sets @video" do
          post :create, review: Fabricate.attributes_for(:review, content: ""), video_id: video.id
          expect(assigns(:video)).to eq(video)
        end

        it "sets @review" do
          review = Fabricate(:review, video: video)
          post :create, review: Fabricate.attributes_for(:review, content: ""), video_id: video.id
          expect(assigns(:reviews)).to match_array([review])
        end
      end
    end

    context "unauthenticated user" do 
      it "does not create a review" do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(Review.count).to eq(0)
      end
      it "redirects the user to the root path" do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(response).to redirect_to root_path
      end
    end  
  end  
end