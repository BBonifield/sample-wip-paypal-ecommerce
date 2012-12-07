require "spec_helper"

describe SessionsController do
  it "routes GET 'login' to #new" do
    get("/login").should route_to("sessions#new")
  end
  it "routes POST 'login' to #create" do
    post("/login").should route_to("sessions#create")
  end

  it "routes GET 'logout' to #destroy" do
    get("/logout").should route_to("sessions#destroy")
  end
end
