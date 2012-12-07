module AddressModelMacros
  module ClassMethods
    # test possible variances of zip codes
    def it_should_validate_format_of_zip_code
      it { should allow_value("01234").for(:zip_code) }
      it { should allow_value("01234-1234").for(:zip_code) }
      it { should_not allow_value("01234-123").for(:zip_code) }
      it { should_not allow_value("01234 1234").for(:zip_code) }
      it { should_not allow_value("012345").for(:zip_code) }
      it { should_not allow_value("0123").for(:zip_code) }
      it { should_not allow_value("1A2B3").for(:zip_code) }
    end

    # ensure that only one address can have a given field set to true within
    # the scope of a single user
    def it_should_ensure_only_one_address_has_field_true field
      it "should ensure only one address has field #{field} set to true" do
        user = FactoryGirl.create :user
        first_address = FactoryGirl.create :address, :user => user, field => true

        # creation of second address with value true should update first's field
        # value to false
        FactoryGirl.create :address, :user => user, field => true

        first_address.reload.send(field).should eq false
      end
    end
  end

  def self.included receiver
    receiver.extend ClassMethods
  end
end
