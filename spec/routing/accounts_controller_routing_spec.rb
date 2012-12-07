require "spec_helper"

describe AccountsController do
  it "routes GET '/account' to #show" do
    get("/account").should route_to("accounts#show")
  end
  it "routes GET '/account/edit' to #edit" do
    get("/account/edit").should route_to("accounts#edit")
  end
  it "routes PUT '/account' to #update" do
    put("/account").should route_to("accounts#update")
  end

  describe "change password" do
    it "routes GET '/account/change_password' to #edit_password" do
      get("/account/change_password").should route_to("accounts#edit_password")
    end
    it "routes PUT '/account/change_password' to #update_password" do
      put("/account/change_password").should route_to("accounts#update_password")
    end
  end

  describe "user addresses" do
    it "routes GET '/addresses' to #index" do
      get("/account/addresses").should route_to("addresses#index")
    end
    it "routes GET '/addresses/new' to #new" do
      get("/account/addresses/new").should route_to("addresses#new")
    end
    it "routes POST '/addresses' to #create" do
      post("/account/addresses").should route_to("addresses#create")
    end
    it "routes GET '/addresses/:id/edit' to #edit" do
      get("/account/addresses/1/edit").should route_to("addresses#edit", :id => "1")
    end
    it "routes PUT '/addresses/:id' to #update" do
      put("/account/addresses/1").should route_to("addresses#update", :id => "1")
    end
    it "routes DELETE '/addresses/:id' to #destroy" do
      delete("/account/addresses/1").should route_to("addresses#destroy", :id => "1")
    end

  end
end
