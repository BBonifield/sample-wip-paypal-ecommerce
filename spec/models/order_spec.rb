require 'spec_helper'

describe Order do

  context "#mass_assignment" do
    it { should allow_mass_assignment_of :shipping_address_id }

    it { should_not allow_mass_assignment_of :offer_id }
    it { should_not allow_mass_assignment_of :state }
  end


  context "#associations" do
    it { should belong_to :offer }
    it { should belong_to(:shipping_address).class_name("Address") }
    it { should have_one(:purchase).dependent(:nullify) }
  end


  context "#validations" do
    it { should validate_presence_of :offer }
    it { should validate_presence_of :shipping_address }
    it { should ensure_inclusion_of(:state).in_array(Order.valid_states) }

    it { should validate_presence_of :terms_and_conditions }
    it { should_not allow_value('0').for(:terms_and_conditions).with_message('must be agreed to') }
    context "#on_update" do
      it "should not validate :terms_and_conditions" do
        o = FactoryGirl.create :order
        o.terms_and_conditions = nil
        o.should be_valid
      end
    end
  end


  context "#default_values" do
    its(:state){ should eq 'new' }
  end


  context "#callbacks" do
    it "enqueues an abandonment checker on create" do
      abandonment_threshold = Order::ABANDONMENT_MINUTE_THRESHOLD
      abandonment_time = abandonment_threshold.minutes
      order_id = 1

      Resque.should_receive(:enqueue_in).
        with(abandonment_time, AbandonedOrderChecker, order_id)

      FactoryGirl.create :order, :id => order_id
    end
  end


  context "#buyer_seller_helpers" do
    subject { FactoryGirl.build :order }
    let(:buyer) { subject.offer.posting.user }
    let(:seller) { subject.offer.inventory_item.user }

    it "provides a helper to access the buyer" do
      subject.buyer.should eq buyer
    end
    it "provides a helper to access the seller" do
      subject.seller.should eq seller
    end
  end

  context "#state_transition" do
    subject { FactoryGirl.create :order }

    def self.it_unaccepts_the_offer_when_transitioning_to_state state_transition
      it "unaccepts the offer" do
        subject.offer.should_receive(:unaccept).and_call_original
        subject.send state_transition
      end
    end

    describe "#purchase_complete" do
      it "adjusts the state to purchase complete" do
        expect {
          subject.purchase_complete
        }.to change(subject, :state).to(Order::STATE_PURCHASE_COMPLETE)
      end
      it "notifies the posting that the purchase is complete" do
        Posting.any_instance.should_receive(:purchase_complete)
        subject.purchase_complete
      end
    end

    describe "#shipped" do
      subject { FactoryGirl.create :order, :purchase_complete }
      it "adjusts the state to shipped" do
        expect {
          subject.shipped
        }.to change(subject, :state).to(Order::STATE_SHIPPED)
      end
    end

    describe "#purchase_failed" do
      it "adjusts the state to purchase failed" do
        expect {
          subject.purchase_failed
        }.to change(subject, :state).to(Order::STATE_PURCHASE_FAILED)
      end
      it_unaccepts_the_offer_when_transitioning_to_state :purchase_failed
    end

    describe "#purchase_cancelled" do
      it "adjusts the state to purchase cancelled" do
        expect {
          subject.purchase_cancelled
        }.to change(subject, :state).to(Order::STATE_PURCHASE_CANCELLED)
      end
      it_unaccepts_the_offer_when_transitioning_to_state :purchase_cancelled
    end

    describe "#purchase_abandoned" do
      it "adjusts the state to purchase abandoned" do
        expect {
          subject.purchase_abandoned
        }.to change(subject, :state).to(Order::STATE_PURCHASE_ABANDONED)
      end
      it_unaccepts_the_offer_when_transitioning_to_state :purchase_abandoned
    end
  end


  describe "finalized?" do
    subject { FactoryGirl.build :order, trait }

    context "when new" do
      let(:trait) { :new }
      its(:finalized?){ should eq false }
    end
    context "when purchase failed" do
      let(:trait) { :purchase_failed }
      its(:finalized?){ should eq true }
    end
    context "when purchase abandoned" do
      let(:trait) { :purchase_abandoned }
      its(:finalized?){ should eq true }
    end
    context "when purchase cancelled" do
      let(:trait) { :purchase_cancelled }
      its(:finalized?){ should eq true }
    end
    context "when purchase complete" do
      let(:trait) { :purchase_complete }
      its(:finalized?){ should eq true }
    end
    context "when shipped" do
      let(:trait) { :shipped }
      its(:finalized?){ should eq true }
    end
  end
end
