require 'spec_helper'

describe "boroughs/edit.html.haml" do
  before(:each) do
    @borough = assign(:borough, stub_model(Borough,
      :name => "MyString",
      :services_id => "MyString"
    ))
  end

  it "renders the edit borough form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => boroughs_path(@borough), :method => "post" do
      assert_select "input#borough_name", :name => "borough[name]"
      assert_select "input#borough_services_id", :name => "borough[services_id]"
    end
  end
end
