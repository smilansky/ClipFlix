require 'spec_helper'

describe VideosController do

  describe "GET index" do

    it "sets the @categories variable for authenticated users" do
      set_current_user
      comedies = Category.create(name: "Movie Comedies")
      dramas = Category.create(name: "Movie Dramas")

      get :index
      expect(assigns(:categories)).to eq([comedies, dramas])
    end
  
    context "unauthenticated user" do
      it_behaves_like "require_sign_in" do
        let(:action) { get :index }
      end
    end  
  end

  describe "GET show" do
    context "passes authentication" do
      let(:ter) { Fabricate(:video) }
      before { set_current_user }
      it "sets the @video variable to the requested video if the user is" do
        get :show, id: ter
        expect(assigns(:video)).to eq(ter)
      end  

      it "sets @reviews to all of the reviews of a particular controller" do
        review1 = Fabricate(:review, video: ter)
        review2 = Fabricate(:review, video: ter)

        get :show, id: ter
        expect(assigns[:reviews]).to match_array([review1, review2])
      end

     it "sets the @review variable" do
      review1 = Fabricate(:review, video: ter)
      get :show, id: ter
      expect(assigns(:reviews)).to eq([review1])
     end
    end

    context "fails authentication" do
      let(:ter) { Fabricate(:video) }
      it "does not set the @video variable to the requested video" do
        get :show, id: ter
        expect(assigns(:video)).to eq(nil)
      end
      it "does not render the show template" do
        get :show, id: ter
        expect(response).to render_template nil
      end
    end
  end

  describe "POST search" do
    let (:terminator) { Fabricate(:video, title: 'Terminator') }
    it "sets @search for authenticated users" do
      set_current_user
      post :search, search_term: "min"
      expect(assigns(:search)).to eq([terminator])
    end

    it_behaves_like "require_sign_in" do
      let(:action) { post :search, search_term: "min" }
    end
  end   
end