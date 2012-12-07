module UserModelMacros
  module ClassMethods
    def it_should_validate_presence_of_an_address_at_signup
      it "should validate presence of an address at signup" do
        user = FactoryGirl.build :new_user_at_signup

        user.should_not be_valid
        user.errors[:base].should include "You must include an address during signup."
      end
    end
  end

  def self.included receiver
    receiver.extend ClassMethods
  end
end
