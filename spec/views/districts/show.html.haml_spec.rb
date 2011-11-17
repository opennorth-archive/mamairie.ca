require 'spec_helper'

describe "districts/show.html.haml" do
  before(:each) do
    @district = assign(:district, stub_model(District,
      :name => "Name",
      :borough => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end
