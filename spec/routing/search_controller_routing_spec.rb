require "spec_helper"

describe SearchController do
  it "routes GET '/' to #index" do
    get("/").should route_to("search#index")
  end

  it "routes GET '/search/postings' to #postings" do
    get("/search/postings").should route_to("search#postings")
  end
end
