require 'spec_helper'

describe VideosController do 
  describe "Get index" do
    it "sets the @categories variable" do
      comedies = Category.create(name: "Movie Comedies")
      dra = Category.create(name: "Movie Dramas")
      user = User.create(fullname: 'joe', email: 'joe@example.com', password: 'password')
      session[:user_id] = user.id

      get :index
      assigns(:categories).should == [com, dra]
    end

    it "renders the index template"
  end
end