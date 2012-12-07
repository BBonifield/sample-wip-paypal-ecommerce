class InventoryGroup < ActiveRecord::Base

  # mass assignment
  attr_accessible :name


  # associations
  belongs_to :user
  has_many :inventory_items,
    :dependent => :nullify


  # validations
  validates_presence_of :name

end
