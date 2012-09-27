require 'spec_helper'

describe PagesController do
  describe 'GET index' do
    it 'should be successful' do
      get :index
      response.code.should == 200
      response.should render_template('index')
    end

    it 'should render the Atom feed' do
      get :index, format: 'atom'
      response.code.should == 200
      response.should render_template('index')
    end
  end

  describe 'GET search' do
    pending
  end
end
