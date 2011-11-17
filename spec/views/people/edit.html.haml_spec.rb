require 'spec_helper'

describe "people/edit.html.haml" do
  before(:each) do
    @person = assign(:person, stub_model(Person,
      :name => "MyString",
      :email => "MyString",
      :borough => nil,
      :party => nil,
      :positions => "",
      :responsibilities => "",
      :wikipedia => "",
      :facebook => "MyString",
      :twitter => "MyString",
      :web => "MyString",
      :photo_url => "MyString",
      :source_id => 1,
      :source_url => "MyString"
    ))
  end

  it "renders the edit person form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => people_path(@person), :method => "post" do
      assert_select "input#person_name", :name => "person[name]"
      assert_select "input#person_email", :name => "person[email]"
      assert_select "input#person_borough", :name => "person[borough]"
      assert_select "input#person_party", :name => "person[party]"
      assert_select "input#person_positions", :name => "person[positions]"
      assert_select "input#person_responsibilities", :name => "person[responsibilities]"
      assert_select "input#person_wikipedia", :name => "person[wikipedia]"
      assert_select "input#person_facebook", :name => "person[facebook]"
      assert_select "input#person_twitter", :name => "person[twitter]"
      assert_select "input#person_web", :name => "person[web]"
      assert_select "input#person_photo_url", :name => "person[photo_url]"
      assert_select "input#person_source_id", :name => "person[source_id]"
      assert_select "input#person_source_url", :name => "person[source_url]"
    end
  end
end
