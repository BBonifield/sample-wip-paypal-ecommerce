require "spec_helper"

describe OrdersController do
  it "routes GET to #new" do
    get("/offers/1/orders/new").should route_to("orders#new", :offer_id => "1")
  end
  it "routes POST to #create" do
    post("/offers/1/orders").should route_to("orders#create", :offer_id => "1")
  end
  it "routes GET to #purchase_process" do
    get("/offers/1/orders/2/purchase_process").
      should route_to("orders#purchase_process", :offer_id => "1", :id => "2")
  end
  it "routes GET to #purchase_failed" do
    get("/offers/1/orders/2/purchase_failed").
      should route_to("orders#purchase_failed", :offer_id => "1", :id => "2")
  end
  it "routes GET to #purchase_cancelled" do
    get("/offers/1/orders/2/purchase_cancelled").
      should route_to("orders#purchase_cancelled", :offer_id => "1", :id => "2")
  end
  it "routes GET to #purchase_complete" do
    get("/offers/1/orders/2/purchase_complete").
      should route_to("orders#purchase_complete", :offer_id => "1", :id => "2")
  end
end
