class ShippingService < ActiveRecord::Base
  attr_accessible :name,
    :logo_identifier,
    :sort_order


  # scope
  default_scope order("sort_order")


  def logo_file_name
    "shipping-service-#{logo_identifier}.png"
  end
end
