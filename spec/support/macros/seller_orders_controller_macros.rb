module SellerOrdersControllerMacros
  module ClassMethods
    def it_ensures_the_user_is_the_seller_for_action action
      it "redirects the user to the root if they are not the order seller" do
        another_user_order = FactoryGirl.create :order, :purchase_complete
        get action, :id => another_user_order.id

        response.should redirect_to root_path
        flash[:error].should eq "You do not have access to the order in question"
      end
    end

    def it_returns_success_and_assigns_the_proper_variables_for_action action
      it "returns http success and assigns the order and a shipping notification" do
        get action, :id => current_user_order.id

        response.should be_success
        assigns(:order).should eq current_user_order
        assigns(:shipping_notification).should be_an_instance_of ShippingNotification
      end
    end
  end

  def self.included receiver
    receiver.extend ClassMethods
  end
end
