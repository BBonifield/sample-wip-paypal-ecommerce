require "spec_helper"

describe InventoryGroupsController do
  it "routes POST '/inventory_groups' to #create with format json" do
    post("/inventory_groups").should route_to("inventory_groups#create", :format => 'json')
  end
end
