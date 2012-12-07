require 'spec_helper'

describe IpnNotification do

  context "#mass_assignment" do
    it { should allow_mass_assignment_of :raw_post }
    it { should allow_mass_assignment_of :paypal_pay_key }
    it { should allow_mass_assignment_of :status }
  end


  context "#validations" do
    it { should validate_presence_of :raw_post }
  end


  context "#notification_processing" do
    let(:associated_order) { FactoryGirl.create :order }
    let(:associated_purchase) { FactoryGirl.create :purchase, :order => associated_order }
    subject {
      FactoryGirl.build :ipn_notification,
        :completed,
        :paypal_pay_key => associated_purchase.paypal_pay_key
    }

    before {
      # stub the order association so we can call should_receives on the
      # proper order object
      Purchase.any_instance.stub(:order).and_return(associated_order)
    }

    context "when the notification is verified" do
      before { stub_paypal_adaptive_notification_as_verified }

      it "marks the associated order as complete" do
        associated_order.should_receive(:purchase_complete).and_call_original
        subject.save
      end
    end

    context "when the notification is unverified" do
      before { stub_paypal_adaptive_notification_as_unverified }

      it "does not mark the associated order as complete" do
        associated_order.should_not_receive(:purchase_complete)
        subject.save
      end
    end
  end

end
