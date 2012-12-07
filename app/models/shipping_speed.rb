class ShippingSpeed < ActiveRecord::Base
  attr_accessible :name,
    :sort_order


  # associations
  has_many :inventory_items,
    :dependent => :nullify


  # scope
  default_scope order("sort_order")
end
