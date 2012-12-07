require "spec_helper"

describe PaypalController do
  it "routes POST to #ipn_notification" do
    post("/paypal/ipn_notification").
      should route_to("paypal#ipn_notification")
  end
end
