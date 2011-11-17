require 'spec_helper'

describe "boroughs/index.html.haml" do
  before(:each) do
    assign(:boroughs, [
      stub_model(Borough,
        :name => "Name",
        :services_id => "Services"
      ),
      stub_model(Borough,
        :name => "Name",
        :services_id => "Services"
      )
    ])
  end

  it "renders a list of boroughs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Services".to_s, :count => 2
  end
end
