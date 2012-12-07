class IpnNotification < ActiveRecord::Base
  STATUS_COMPLETED = "COMPLETED"

  attr_accessible :raw_post,
    :paypal_pay_key,
    :status

  validates_presence_of :raw_post

  after_create :process_notification


  private


  def process_notification
    if associated_order_exists? && notification_is_verified?
      case self.status
        when STATUS_COMPLETED
          associated_order.purchase_complete
      end
    end
  end

  def associated_order_exists?
    associated_order.present?
  end

  def associated_order
    purchase = Purchase.find_by_paypal_pay_key self.paypal_pay_key

    return purchase.order if purchase.present?
    nil
  end

  def notification_is_verified?
    notification = PaypalAdaptive::IpnNotification.new
    notification.send_back self.raw_post

    notification.verified?
  end
end
