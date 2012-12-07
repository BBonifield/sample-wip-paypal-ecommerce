require "spec_helper"

describe InventoryItemsController do
  it "routes GET '/inventory' to #index" do
    get("/inventory").should route_to("inventory_items#index")
  end
  it "routes GET '/inventory/in_group/:inventory_group_id' to #index" do
    get("/inventory/in_group/1").should route_to("inventory_items#index", :inventory_group_id => "1")
  end
  it "routes GET '/inventory/pending_delivery' to #pending_delivery" do
    get("/inventory/pending_delivery").should route_to("inventory_items#pending_delivery")
  end

  it "routes GET '/inventory/new' to #new" do
    get("/inventory/new").should route_to("inventory_items#new")
  end
  it "routes POST '/inventory' to #create" do
    post("/inventory").should route_to("inventory_items#create")
  end

  it "routes GET '/inventory/:id/edit' to #edit" do
    get("/inventory/1/edit").should route_to("inventory_items#edit", :id => "1")
  end
  it "routes PUT '/inventory/:id' to #update" do
    put("/inventory/1").should route_to("inventory_items#update", :id => "1")
  end

  it "routes DELETE '/inventory/:id' to #destroy" do
    delete("/inventory/1").should route_to("inventory_items#destroy", :id => "1")
  end

  it "routes POST '/inventory/:id/increment_quantity' to #increment_quantity" do
    post("/inventory/1/increment_quantity").should route_to("inventory_items#increment_quantity", :id => "1")
  end
  it "routes POST '/inventory/:id/decrement_quantity' to #decrement_quantity" do
    post("/inventory/1/decrement_quantity").should route_to("inventory_items#decrement_quantity", :id => "1")
  end
end
