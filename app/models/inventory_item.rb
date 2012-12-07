class InventoryItem < ActiveRecord::Base
  mount_uploader :inventory_image, ImageUploader

  # mass assignment
  attr_accessible :category_id,
    :condition_id,
    :shipping_speed_id,
    :inventory_group_id,
    :name,
    :details,
    :quantity,
    :shipping_cost,
    :keyword_1,
    :keyword_2,
    :keyword_3,
    :keyword_4,
    :keyword_5,
    :keyword_6,
    :inventory_image,
    :inventory_image_cache # for carrierwave file retention in forms


  # associations
  belongs_to :user
  belongs_to :category
  belongs_to :condition
  belongs_to :shipping_speed
  belongs_to :inventory_group
  has_many :offers,
    :dependent => :destroy


  # validations
  validates_presence_of :user,
    :category,
    :condition,
    :shipping_speed
  validates_presence_of :name,
    :details,
    :inventory_image
  validates_numericality_of :quantity,
    :only_integer => true,
    :greater_than => 0
  validates_numericality_of :shipping_cost,
    :greater_than => 0


  # scopes

  # retrieve the inventory items that have orders that are in the purchase
  # complete state
  scope :pending_delivery,
    includes(:offers => [:order]).where("orders.state = ?", Order::STATE_PURCHASE_COMPLETE)

  def associated_order
    offers.includes(:order).where("orders.state = ?", Order::STATE_PURCHASE_COMPLETE).first.try(:order)
  end


  # quantity management
  def decrement_quantity
    self.quantity = self.quantity - 1
    self.save
  end

  def increment_quantity
    self.quantity = self.quantity + 1
    self.save
  end
end
