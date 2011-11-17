require 'spec_helper'

describe "parties/edit.html.haml" do
  before(:each) do
    @party = assign(:party, stub_model(Party,
      :name => "MyString"
    ))
  end

  it "renders the edit party form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => parties_path(@party), :method => "post" do
      assert_select "input#party_name", :name => "party[name]"
    end
  end
end
