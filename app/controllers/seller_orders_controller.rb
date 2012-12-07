class SellerOrdersController < ApplicationController
  before_filter :require_login
  before_filter :load_and_authorize_order

  def mark_shipped
    @shipping_notification = ShippingNotification.new
    @shipping_notification.order_id = params[:id]
  end

  def preview_shipped
    @shipping_notification = ShippingNotification.new params[:shipping_notification]
    @shipping_notification.order_id = params[:id]

    if params[:send_shipping_notification].present?
      unless @shipping_notification.valid?
        render :mark_shipped
      end
    else
      mark_order_as_shipped
      redirect_to pending_delivery_inventory_items_path,
        :notice => "The order has been marked as shipped"
    end
  end

  def confirm_shipped
    @shipping_notification = ShippingNotification.new params[:shipping_notification]
    @shipping_notification.order_id = params[:id]

    if @shipping_notification.send_notification
      mark_order_as_shipped
      redirect_to pending_delivery_inventory_items_path,
        :notice => "The shipping notification has been sent"
    else
      render :preview_shipped
    end
  end


  private


  def mark_order_as_shipped
    @order.shipped
  end

  def submitted_attributes
  end

  def load_and_authorize_order
    @order = Order.find params[:id]

    # ensure that the user is the seller
    unless @order.seller == current_user
      redirect_to root_path,
        :flash => { :error => "You do not have access to the order in question" }
    end
  end

end
