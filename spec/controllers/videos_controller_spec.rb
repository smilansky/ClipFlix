require 'spec_helper'

describe VideosController do

  describe "GET index" do

      it "sets the @categories variable for authenticated users" do
        session[:user_id] = Fabricate(:user).id
        comedies = Category.create(name: "Movie Comedies")
        dramas = Category.create(name: "Movie Dramas")

        get :index
        expect(assigns(:categories)).to eq([comedies, dramas])
      end
      
      it "redirects the user to the root path for unauthenticated users" do
        get :index
        expect(response).to redirect_to root_path
      end
  end

  describe "GET show" do
    context "passes authentication" do
      before :each do
        session[:user_id] = Fabricate(:user)
        @ter = Video.create(title: 'Terminator 2', description: 'Action Movie')
      end

      it "sets the @video variable to the requested video" do
        get :show, id: @ter
        expect(assigns(:video)).to eq(@ter)
      end  

      it "sets @reviews to all of the reviews of a particular controller" do
        review1 = Fabricate(:review, video: @ter)
        review2 = Fabricate(:review, video: @ter)

        get :show, id: @ter
        expect(assigns[:reviews]).to match_array([review1, review2])

      end

    end

    context "fails authentication" do
      before :each do
        @ter = Video.create(title: 'Terminator 2', description: 'Action Movie')
      end
      it "does not set the @video variable to the requested video" do
        get :show, id: @ter
        expect(assigns(:video)).to eq(nil)
      end
      it "does not render the show template" do
        get :show, id: @ter
        expect(response).to render_template nil
      end
    end
  end

  describe "POST search" do
    it "sets @search for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      terminator = Fabricate(:video, title: 'Terminator')
      post :search, search_term: "min"
      expect(assigns(:search)).to eq([terminator])
    end

    it "redirects the user to the root path for unauthenticated users" do
      terminator = Fabricate(:video, title: 'Terminator')
      post :search, search_term: "min"
      expect(response).to redirect_to root_path
    end
  end  
end