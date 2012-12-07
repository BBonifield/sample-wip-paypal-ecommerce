class OrdersController < ApplicationController
  before_filter :require_login
  before_filter :load_and_authorize_offer
  before_filter :load_order
  before_filter :ensure_order_is_not_finalized, :only => :purchase_process

  def new
  end

  def create
    @order.assign_attributes params[:order]

    if @order.save
      redirect_to purchase_process_offer_order_path(@offer, @order)
    else
      render :new
    end
  end

  # send the actual paypal pay request
  def purchase_process
    @purchase = @order.build_purchase purchase_urls
    if @purchase.save
      if @purchase.response.success?
        redirect_to @purchase.response.approve_paypal_payment_url
      else
        response_error = @purchase.response.errors.first['message']
        full_error = "Failed to finalize payment: #{response_error}"
        redirect_to purchase_failed_offer_order_path(@offer, @order),
          :flash => { :error => full_error }
      end
    else
      redirect_to purchase_failed_offer_order_path(@offer, @order),
        :flash => { :error => "The purchase could not be created." }
    end
  end

  # the purchase failed to be created properly for some reason
  def purchase_failed
    @order.purchase_failed
  end

  # the user cancelled the purchase while at the paypal page (e.g. didn't finalize payment)
  def purchase_cancelled
    @order.purchase_cancelled
  end

  # the user finished the checkout process with paypal
  def purchase_complete
    # purposely not marking the order as complete yet since paypal sends
    # notifications for this purpose
  end


  private

  def load_and_authorize_offer
    @offer = Offer.find params[:offer_id]

    # ensure the user owns the posting
    unless @offer.posting.user == current_user
      redirect_to root_path,
        :flash => { :error => "You do not have access to the posting in question" }
    end
  end

  def load_order
    @order = @offer.order || @offer.build_order
  end

  # ensure that the user doesn't double submit certain actions or access
  # pages that shouldn't be available once the order is complete
  def ensure_order_is_not_finalized
    if @order.finalized?
      redirect_to root_path,
        :flash => { :error => "You cannot resubmit that order.  It has already been finalized" }
    end
  end


  def purchase_urls
    use_port = nil
    if Rails.env.development? && ENV['CALLBACK_TUNNEL_HOST'].present?
      use_host = ENV['CALLBACK_TUNNEL_HOST']
    else
      use_host = request.host
      use_port = request.port unless request.port == 80
    end

    {
      :return_url => purchase_complete_offer_order_url(@offer, @order),
      :cancel_url => purchase_cancelled_offer_order_url(@offer, @order),
      :ipn_notification_url => paypal_ipn_notification_url(:host => use_host, :port => use_port)
    }
  end

end
