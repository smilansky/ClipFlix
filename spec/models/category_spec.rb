require 'spec_helper'

describe Category do
  it "saves itself" do
    category = Category.new(name: "Mysteries")
    category.save
    Category.first.should == category
  end

  it { should have_many(:videos)}

end