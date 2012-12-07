class PostingsController < ApplicationController
  before_filter :require_login
  before_filter :load_posting, :except => :index

  def index
    @postings = current_user.postings
  end

  def new
    # pull through params that are passed from the search results page
    @posting.assign_attributes params[:posting]

    # template out the new posting using the existing posting
    if params[:template_posting_id].present?
      template_posting = Posting.find params[:template_posting_id]
      @posting.template_from_posting template_posting
    end
  end

  def create
    save_posting_or_render_template :new, "Posting has been created."
  end

  def edit
  end

  def update
    save_posting_or_render_template :edit, "Posting has been updated."
  end

  def destroy
    @posting.destroy
    redirect_to postings_path, :notice => "Posting has been deleted."
  end

  # temporary seed functionality that will be removed in a future
  # iteration
  def seed_offer
    offer = @posting.offers.build :price => 150
    offer.inventory_item = random_inventory_item
    offer.price

    if offer.inventory_item.nil?
      redirect_to postings_path, :notice => "Cannot seed offer because there are no users that have inventory items.  Another user on the system needs an item.  Consider creatig a second account and adding an inventory item."
    else
      offer.save!
      redirect_to new_offer_order_path(offer)
    end
  end
  def random_inventory_item
    InventoryItem.where("user_id != ?", current_user.id).first
  end


  protected


  def save_posting_or_render_template template, success_message
    @posting.assign_attributes params[:posting]

    if @posting.save
      redirect_to postings_path, :notice => success_message
    else
      render template
    end
  end

  def load_posting
    if params[:id]
      @posting = current_user.postings.find params[:id]
    else
      @posting = current_user.postings.build
    end
  end
end
