class PaypalController < ApplicationController
  before_filter :require_logged_out

  # triggered when payments are actually received by paypal
  def ipn_notification
    IpnNotification.create :raw_post => request.raw_post,
      :paypal_pay_key => params[:pay_key],
      :status => params[:status]
    head 200
  end

end
