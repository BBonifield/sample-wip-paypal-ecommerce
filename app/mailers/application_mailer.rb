class ApplicationMailer < ActionMailer::Base
  default :from => "service@clintsboard.com"
  layout "application_mailer"

  # bring in application helper methods for view rendering
  helper :application

  def shipping_notification_for_buyer shipping_notification
    @shipping_notification = shipping_notification
    @order = shipping_notification.order
    mail(:to => shipping_notification.order.buyer.email,
         :subject => "Your order has been shipped")
  end
end
