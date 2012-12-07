require 'spec_helper'

describe Purchase do

  context "#mass_assignment" do
    it { should allow_mass_assignment_of :return_url }
    it { should allow_mass_assignment_of :cancel_url }
    it { should allow_mass_assignment_of :ipn_notification_url }

    it { should_not allow_mass_assignment_of :response }
    it { should_not allow_mass_assignment_of :amount }
    it { should_not allow_mass_assignment_of :fee_amount }
    it { should_not allow_mass_assignment_of :seller_amount }
    it { should_not allow_mass_assignment_of :paypal_pay_key }
    it { should_not allow_mass_assignment_of :order_id }
  end


  context "#attributes" do
    it { should respond_to :response }
    it { should respond_to :return_url }
    it { should respond_to :cancel_url }
    it { should respond_to :ipn_notification_url }
  end


  context "#associations" do
    it { should belong_to :order }
  end


  context "#validations" do
    it { should validate_presence_of :order }
    it { should validate_presence_of :return_url }
    it { should validate_presence_of :cancel_url }
    it { should validate_presence_of :ipn_notification_url }
  end


  context "#paypal_integration" do
    subject{ FactoryGirl.build :purchase }

    let(:site_fee_percent) { Purchase::SITE_FEE_PERCENTAGE }
    let(:site_paypal_email) { ENV['PAYPAL_FEES_EMAIL'] }
    let(:expected_amount) {
      (subject.order.offer.price + subject.order.offer.inventory_item.shipping_cost).round(2)
    }
    let(:expected_fee_amount) {
      (expected_amount * site_fee_percent).round(2)
    }
    let(:expected_seller_amount) {
      (expected_amount - expected_fee_amount).round(2)
    }

    context "#amount_calculation" do
      it "calculates and sets the proper amounts during creation" do
        subject.save

        subject.amount.should eq expected_amount
        subject.fee_amount.should eq expected_fee_amount
        subject.seller_amount.should eq expected_seller_amount
      end
    end

    context "#payment_processing" do
      let(:receivers){
        [
          { "email" => subject.order.seller.email, "amount" => expected_amount, "primary" => true },
          { "email" => site_paypal_email, "amount" => expected_fee_amount }
        ]
      }
      let(:pay_request_data) {
        {
        "returnUrl"          => subject.return_url,
        "requestEnvelope"    => {"errorLanguage" => "en_US"},
        "currencyCode"       => "USD",
        "receiverList"       => { "receiver" => receivers },
        "cancelUrl"          => subject.cancel_url,
        "actionType"         => "PAY",
        "ipnNotificationUrl" => subject.ipn_notification_url
        }
      }

      it "sends a pay request on create" do
        PaypalAdaptive::Request.any_instance.
          should_receive(:pay).
          with(pay_request_data)

        subject.save
      end

      it "makes the pay response publicly accessible after the request is made" do
        expect {
          subject.save
        }.to change(subject, :response)
      end

      it "stores the pay response data after the request is made" do
        response = PaypalAdaptive::FakeResponse.new :success => true
        serialized_response = Marshal.dump(response)
        stub_paypal_adaptive_pay_with_response response

        subject.save

        subject.serialized_response.should eq serialized_response
        subject.paypal_pay_key.should eq response['payKey']
      end
    end

    context "#response_persistence_on_initialization" do
      let(:previous_response) { "response" }
      let(:existing_purchase_id){
        purchase = FactoryGirl::create(:purchase)
        purchase.serialized_response = Marshal.dump(previous_response)
        purchase.save!
        purchase.id
      }
      let(:existing_purchase_id_with_malformed_response){
        purchase = FactoryGirl::create(:purchase)
        purchase.serialized_response = "malformed"
        purchase.save!
        purchase.id
      }
      it "makes the previous pay response publicly accessible" do
        purchase = Purchase.find existing_purchase_id
        purchase.response.should eq previous_response
      end
      it "makes the previous pay response nil if the serialized response is invalid" do
        purchase = Purchase.find existing_purchase_id_with_malformed_response
        purchase.response.should be_nil
      end
    end
  end
end
