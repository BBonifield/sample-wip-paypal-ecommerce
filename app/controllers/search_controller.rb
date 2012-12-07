class SearchController < ApplicationController
  def index
  end

  def postings
    # TODO: Still need to flesh this out.  Mocked for now.
    @results = Posting.all
    # serialize the search params into an object that can be added to
    # a get request and ultimately seed a new posting form
    @serialized_search_params = { :posting => { :name => params[:search_string], :price => params[:search_price] } }
  end
end
