class Address < ActiveRecord::Base

  # mass assignment
  attr_accessible :address_1,
    :address_2,
    :name,
    :city,
    :state,
    :zip_code,
    :is_default_billing,
    :is_default_shipping


  # associations
  belongs_to :user


  # validations
  validates :name,
    :presence => true,
    :uniqueness => { :scope => :user_id }
  validates_presence_of :address_1
  validates_presence_of :city
  validates_length_of :state,
    :is => 2
  validates_format_of :zip_code,
    :with => /^\d{5}(-\d{4})?$/,
    :message => "is not a valid zip code"
  validates_presence_of :user


  # hooks
  before_save :ensure_is_default_exclusivity


  private


  # ensure that only one address is marked as the default shipping
  # or default billing address
  def ensure_is_default_exclusivity
    [:is_default_shipping, :is_default_billing].each do |exclusive_field|
      if self.send(exclusive_field) == true
        undefault_sibling_addresses_for_field exclusive_field
      end
    end
  end

  # set the is_default_*** field to false on all addresses belonging
  # to the same user
  def undefault_sibling_addresses_for_field field
    user.addresses.where("id != ? AND #{field} = ?", (self.id.nil? ? 0 : self.id), true).each do |conflicting_address|
      conflicting_address.update_attribute field, false
    end
  end
end
