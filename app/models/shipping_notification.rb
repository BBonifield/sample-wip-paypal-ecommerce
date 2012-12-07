class ShippingNotification
  include ActiveModel::Validations

  attr_accessor :tracking_number,
    :shipping_service_id,
    :order_id,
    :note

  validates_presence_of :tracking_number,
    :shipping_service_id,
    :order_id


  def initialize(attributes = {})
    assign_attributes attributes
  end


  def order
    Order.find_by_id order_id
  end

  def shipping_service
    ShippingService.find_by_id shipping_service_id
  end


  def send_notification
    if valid?
      do_send_notification
      true
    else
      false
    end
  end


  private


  def do_send_notification
    ApplicationMailer.shipping_notification_for_buyer(self).deliver
  end


  def assign_attributes attributes
    if attributes.present?
      attributes.each do |field, value|
        field_setter = "#{field}=".to_sym
        begin
          self.send(field_setter, value)
        rescue
          # don't worry about it if there are extra attributes
        end
      end
    end
  end
end
