require 'spec_helper'

describe "boroughs/new.html.haml" do
  before(:each) do
    assign(:borough, stub_model(Borough,
      :name => "MyString",
      :services_id => "MyString"
    ).as_new_record)
  end

  it "renders new borough form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => boroughs_path, :method => "post" do
      assert_select "input#borough_name", :name => "borough[name]"
      assert_select "input#borough_services_id", :name => "borough[services_id]"
    end
  end
end
