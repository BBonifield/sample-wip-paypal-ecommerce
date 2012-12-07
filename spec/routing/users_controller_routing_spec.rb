require "spec_helper"

describe UsersController do
  it "routes GET new to #new" do
    get("/users/new").should route_to("users#new")
  end
  it "routes POST create to #create" do
    post("/users").should route_to("users#create")
  end
end
