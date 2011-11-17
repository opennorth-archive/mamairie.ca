require 'spec_helper'

describe "boroughs/show.html.haml" do
  before(:each) do
    @borough = assign(:borough, stub_model(Borough,
      :name => "Name",
      :services_id => "Services"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Services/)
  end
end
