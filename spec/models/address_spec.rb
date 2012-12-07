require 'spec_helper'

describe Address do
  include AddressModelMacros

  context "#mass_assignment" do
    it { should allow_mass_assignment_of :name }
    it { should allow_mass_assignment_of :address_1 }
    it { should allow_mass_assignment_of :address_2 }
    it { should allow_mass_assignment_of :city }
    it { should allow_mass_assignment_of :state }
    it { should allow_mass_assignment_of :zip_code }
    it { should allow_mass_assignment_of :is_default_billing }
    it { should allow_mass_assignment_of :is_default_shipping }
    it { should_not allow_mass_assignment_of :user }
  end


  context "#associations" do
    it { should belong_to :user }
  end


  context "#validations" do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
    it { should validate_presence_of :address_1 }
    it { should validate_presence_of :city }
    it { should validate_presence_of :user }

    it { should ensure_length_of(:state).is_equal_to(2) }

    it_should_validate_format_of_zip_code
  end


  context "#defaults" do
    it { should default_field(:is_default_shipping).to_value(false) }
    it { should default_field(:is_default_billing).to_value(false) }
  end

  context "default address exclusivity" do
    it_should_ensure_only_one_address_has_field_true :is_default_shipping
    it_should_ensure_only_one_address_has_field_true :is_default_billing
  end

end
