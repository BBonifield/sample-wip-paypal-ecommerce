require "spec_helper"

describe PostingsController do
  it "routes GET '/postings' to #index" do
    get("/postings").should route_to("postings#index")
  end
  it "routes GET '/postings/new' to #new" do
    get("/postings/new").should route_to("postings#new")
  end
  it "routes POST '/postings' to #create" do
    post("/postings").should route_to("postings#create")
  end
  it "routes GET '/postings/:id/edit' to #edit" do
    get("/postings/1/edit").should route_to("postings#edit", :id => "1")
  end
  it "routes PUT '/postings/:id' to #update" do
    put("/postings/1").should route_to("postings#update", :id => "1")
  end
  it "routes DELETE '/postings/:id' to #destroy" do
    delete("/postings/1").should route_to("postings#destroy", :id => "1")
  end
end
