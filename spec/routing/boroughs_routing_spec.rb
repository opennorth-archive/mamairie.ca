require "spec_helper"

describe BoroughsController do
  describe "routing" do

    it "routes to #index" do
      get("/boroughs").should route_to("boroughs#index")
    end

    it "routes to #new" do
      get("/boroughs/new").should route_to("boroughs#new")
    end

    it "routes to #show" do
      get("/boroughs/1").should route_to("boroughs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/boroughs/1/edit").should route_to("boroughs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/boroughs").should route_to("boroughs#create")
    end

    it "routes to #update" do
      put("/boroughs/1").should route_to("boroughs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/boroughs/1").should route_to("boroughs#destroy", :id => "1")
    end

  end
end
