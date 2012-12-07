require 'spec_helper'

describe ShippingService do

  context "#mass_assignment" do
    it { should allow_mass_assignment_of :name }
    it { should allow_mass_assignment_of :logo_identifier }
    it { should allow_mass_assignment_of :sort_order }
  end


  context "#default scope" do
    include OrderingMacros
    klass_should_order_by ShippingService, :sort_order
  end


  describe "logo_file_name" do
    it "returns the proper value" do
      service = ShippingService.new :logo_identifier => 'foobar'

      service.logo_file_name.should eq "shipping-service-foobar.png"
    end
  end
end
