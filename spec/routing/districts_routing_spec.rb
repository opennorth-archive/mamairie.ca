require "spec_helper"

describe DistrictsController do
  describe "routing" do

    it "routes to #index" do
      get("/districts").should route_to("districts#index")
    end

    it "routes to #new" do
      get("/districts/new").should route_to("districts#new")
    end

    it "routes to #show" do
      get("/districts/1").should route_to("districts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/districts/1/edit").should route_to("districts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/districts").should route_to("districts#create")
    end

    it "routes to #update" do
      put("/districts/1").should route_to("districts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/districts/1").should route_to("districts#destroy", :id => "1")
    end

  end
end
