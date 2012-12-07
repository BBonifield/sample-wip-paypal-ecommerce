module SellerOrdersHelper
  def shipping_notification_fields
    [ 'shipping_service_id',
      'shipping_speed_id',
      'tracking_number',
      'note' ]
  end
end
