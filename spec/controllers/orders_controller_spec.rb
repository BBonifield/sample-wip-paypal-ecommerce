require 'spec_helper'

describe OrdersController do

  it_should_require_login_for_actions :new,
    :create,
    :purchase_failed,
    :purchase_process,
    :purchase_complete,
    :offer_id => 1


  before { login_user }

  let(:current_user_offer) {
    user_posting = FactoryGirl.create :posting, :user => current_user
    FactoryGirl.create :offer, :posting => user_posting
  }
  let(:required_params) { { :offer_id => current_user_offer.id } }

  describe "GET :new" do
    it "returns http success" do
      get :new, required_params
      response.should be_success
    end
    it "assigns the offer" do
      get :new, required_params
      assigns(:offer).should eq current_user_offer
    end
    it "assigns a new order" do
      get :new, required_params
      assigns(:order).should be_a_new Order
    end
  end

  describe "POST :create" do
    context "given invalid params" do
      it "assigns the unsaved order" do
        post :create, required_params
        assigns(:order).should be_a_new Order
      end
      it "assigns the offer" do
        post :create, required_params
        assigns(:offer).should eq current_user_offer
      end
      it "re-renders the new template" do
        post :create, required_params
        response.should render_template :new
      end
    end

    context "given valid params" do
      let(:valid_params) {
        required_params.merge({
          :order => {
            :shipping_address_id => FactoryGirl.create(:address, :user => current_user).id,
            :terms_and_conditions => '1'
          }
        })
      }

      it "creates a new offer order" do
        expect {
          post :create, valid_params
        }.to change(Order, :count).by(1)
        Order.last.offer.should eq current_user_offer
      end
      it "redirects to the purchase process page" do
        post :create, valid_params
        response.should redirect_to purchase_process_offer_order_path(current_user_offer, Order.last)
      end
    end
  end

  context "#member_routes" do
    include OrdersControllerMacros

    let(:current_user_order) {
      FactoryGirl.create :order, :offer => current_user_offer
    }
    let(:required_params) {{
      :offer_id => current_user_offer.id,
      :id => current_user_order.id
    }}


    describe "GET :purchase_process" do

      it "ensures that the order hasn't been finalized" do
        check_for_already_finalized_redirect :purchase_process
      end

      context "when the purchase succeeds" do
        it "creates a new purchase" do
          check_creation_and_assignment_of_purchase
        end
        it "redirects the user to etsy" do
          get :purchase_process, required_params
          response.should redirect_to current_user_order.purchase.response.approve_paypal_payment_url
        end
      end

      context "when the purchase fails" do
        before { stub_paypal_adaptive_with_failed_response }

        it "creates a new purchase" do
          check_creation_and_assignment_of_purchase
        end
        it "redirects to the purchase failed page" do
          get :purchase_process, required_params
          response.should redirect_to purchase_failed_offer_order_path(current_user_offer, current_user_order)
        end
        it "adds the first response error to the error flash" do
          get :purchase_process, required_params
          response_error = current_user_order.purchase.response.errors.first['message']
          full_error = "Failed to finalize payment: #{response_error}"
          flash[:error].should eq full_error
        end
      end
    end

    describe "GET :purchase_complete" do
      it "returns http success" do
        check_response_success :purchase_complete
      end
      it "assigns the order" do
        check_assigns_the_order :purchase_complete
      end
    end

    describe "GET :purchase_cancelled" do
      it "returns http success" do
        check_response_success :purchase_cancelled
      end
      it "assigns the order" do
        check_assigns_the_order :purchase_cancelled
      end
      it "marks the order as purchase failed" do
        Order.any_instance.should_receive(:purchase_cancelled)
        get :purchase_cancelled, required_params
      end
    end

    describe "GET :purchase_failed" do
      it "returns http success" do
        check_response_success :purchase_failed
      end
      it "assigns the order" do
        check_assigns_the_order :purchase_failed
      end
      it "marks the order as purchase failed" do
        Order.any_instance.should_receive(:purchase_failed)
        get :purchase_failed, required_params
      end
    end

  end

end
