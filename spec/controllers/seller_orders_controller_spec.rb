require 'spec_helper'

describe SellerOrdersController do
  include SellerOrdersControllerMacros

  it_should_require_login_for_actions :mark_shipped,
    :confirm_shipped

  it "should persist the shipping notifications"
  it "should not allow a double submit on create"


  before { login_user }

  # the current_user has to be the seller
  let(:current_user_order) {
    # the user who owns the inventory is the seller
    user_inventory = FactoryGirl.create :inventory_item, :user => current_user
    offer = FactoryGirl.create :offer, :inventory_item => user_inventory

    FactoryGirl.create :order, :purchase_complete, :offer => offer
  }

  describe "GET :mark_shipped" do
    it_ensures_the_user_is_the_seller_for_action :mark_shipped
    it_returns_success_and_assigns_the_proper_variables_for_action :mark_shipped
  end

  describe "POST :preview_shipped" do
    context "when the user doesn't want to send a notification" do
      let(:no_notification_params) {
        { :id => current_user_order.id,
          :send_shipping_notification => nil }
      }

      it "marks the order as shipped" do
        post :preview_shipped, no_notification_params
        current_user_order.reload.state.should eq Order::STATE_SHIPPED
      end
      it "redirects the user to the items pending delivery page" do
        post :preview_shipped, no_notification_params
        response.should redirect_to pending_delivery_inventory_items_path
        flash[:notice].should eq "The order has been marked as shipped"
      end
    end

    context "when the user wants to send a notification" do
      context "with invalid params" do
        let(:invalid_params) {
          { :id => current_user_order.id,
            :send_shipping_notification => "1" }
        }

        it "rerenders the form template" do
          post :preview_shipped, invalid_params
          response.should render_template :mark_shipped
        end
      end

      context "with valid params" do
        let(:valid_params) {
          { :id => current_user_order.id,
            :send_shipping_notification => "1",
            :shipping_notification => FactoryGirl.attributes_for(:shipping_notification) }
        }

        it "renders the preview template" do
          post :preview_shipped, valid_params
          response.should render_template :preview_shipped
        end
      end
    end
  end

  describe "POST :confirm_shipped" do
    it_ensures_the_user_is_the_seller_for_action :confirm_shipped

    context "with valid params" do
      let(:valid_params) {
        { :id => current_user_order.id,
          :shipping_notification => FactoryGirl.attributes_for(:shipping_notification) }
      }
      it "sends the notification" do
        ShippingNotification.any_instance.
          should_receive(:send_notification)
        post :confirm_shipped, valid_params
      end
      it "marks the order as shipped" do
        post :confirm_shipped, valid_params
        current_user_order.reload.state.should eq Order::STATE_SHIPPED
      end
      it "redirects back to the items pending delivery page" do
        post :confirm_shipped, valid_params
        response.should redirect_to pending_delivery_inventory_items_path
        flash[:notice].should eq "The shipping notification has been sent"
      end
    end

    context "with invalid params" do
      it_returns_success_and_assigns_the_proper_variables_for_action :mark_shipped
      it "re-renders the preview template" do
        post :confirm_shipped, :id => current_user_order.id
        response.should render_template :preview_shipped
      end
    end
  end
end
