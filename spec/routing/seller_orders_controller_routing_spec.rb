require "spec_helper"

describe SellerOrdersController do
  it "routes GET to #mark_shipped" do
    get("/seller_orders/1/mark_shipped").
      should route_to("seller_orders#mark_shipped", :id => "1")
  end
  it "routes POST to #preview_shipped" do
    post("/seller_orders/1/preview_shipped").
      should route_to("seller_orders#preview_shipped", :id => "1")
  end
  it "routes POST to #confirm_shipped" do
    post("/seller_orders/1/confirm_shipped").
      should route_to("seller_orders#confirm_shipped", :id => "1")
  end
end
