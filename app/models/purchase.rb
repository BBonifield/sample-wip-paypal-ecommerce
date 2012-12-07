class Purchase < ActiveRecord::Base
  # used to indicate the percentage that clintsboard takes from
  # each transaction
  SITE_FEE_PERCENTAGE = 0.03


  # custom attrs to set/get transient attributes
  attr_accessor :response,
    :return_url,
    :cancel_url,
    :ipn_notification_url

  attr_accessible :return_url,
    :cancel_url,
    :ipn_notification_url


  # associations
  belongs_to :order


  # validations
  validates_presence_of :order,
    :return_url,
    :cancel_url,
    :ipn_notification_url


  # hooks
  after_initialize :unserialize_response

  before_create :process_paypal_request


  private


  def unserialize_response
    if self.serialized_response.present?
      self.response = Marshal.load(self.serialized_response) rescue nil
    end
  end


  def process_paypal_request
    calculate_and_set_amounts
    response = send_paypal_request
    persist_paypal_response response
  end


  def calculate_and_set_amounts
    self.amount = calculate_amount
    self.fee_amount = calculate_fee_amount self.amount
    self.seller_amount = calculate_seller_amount self.amount, self.fee_amount
  end

  # the total amount of the transaction
  def calculate_amount
    (order.offer.price + order.offer.inventory_item.shipping_cost).round(2)
  end

  # the amount clintsboard takes as a fee
  def calculate_fee_amount base_amount
    (base_amount * SITE_FEE_PERCENTAGE).round(2)
  end

  # the amount the seller takes after the site fee
  def calculate_seller_amount base_amount, fee_amount
    (base_amount - fee_amount).round(2)
  end


  def send_paypal_request
    request = PaypalAdaptive::Request.new
    request.pay pay_request_data
  end

  def persist_paypal_response response
    self.paypal_pay_key = response['payKey']
    self.response = response
    self.serialized_response = Marshal::dump response
  end

  # the data payload to send with the pay request
  def pay_request_data
    {
    "returnUrl"          => return_url,
    "requestEnvelope"    => {"errorLanguage" => "en_US"},
    "currencyCode"       => "USD",
    "receiverList"       => { "receiver" => receivers },
    "cancelUrl"          => cancel_url,
    "actionType"         => "PAY",
    "ipnNotificationUrl" => ipn_notification_url
    }
  end

  def receivers
    # the seller is the primary recipient
    # clintsboard is the secondary recipient
    [
      { "email" => order.seller.email, "amount" => amount, "primary" => true },
      { "email" => ENV['PAYPAL_FEES_EMAIL'], "amount" => fee_amount }
    ]
  end
end
