require 'spec_helper'

describe "Boroughs" do
  describe "GET /boroughs" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get boroughs_path
      response.status.should be(200)
    end
  end
end
