require "spec_helper"

describe PartiesController do
  describe "routing" do

    it "routes to #index" do
      get("/parties").should route_to("parties#index")
    end

    it "routes to #new" do
      get("/parties/new").should route_to("parties#new")
    end

    it "routes to #show" do
      get("/parties/1").should route_to("parties#show", :id => "1")
    end

    it "routes to #edit" do
      get("/parties/1/edit").should route_to("parties#edit", :id => "1")
    end

    it "routes to #create" do
      post("/parties").should route_to("parties#create")
    end

    it "routes to #update" do
      put("/parties/1").should route_to("parties#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/parties/1").should route_to("parties#destroy", :id => "1")
    end

  end
end
