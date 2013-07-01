require 'spec_helper'

describe Category do
  it "should have many videos" do
    category = Category .reflect_on_association(:videos)
    category.macro.should == :has_many 
  end
end