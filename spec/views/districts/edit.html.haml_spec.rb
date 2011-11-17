require 'spec_helper'

describe "districts/edit.html.haml" do
  before(:each) do
    @district = assign(:district, stub_model(District,
      :name => "MyString",
      :borough => nil
    ))
  end

  it "renders the edit district form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => districts_path(@district), :method => "post" do
      assert_select "input#district_name", :name => "district[name]"
      assert_select "input#district_borough", :name => "district[borough]"
    end
  end
end
