require 'spec_helper'

describe Offer do

  context "#mass_assignment" do
    it { should allow_mass_assignment_of :inventory_item_id }
    it { should allow_mass_assignment_of :price }

    it { should_not allow_mass_assignment_of :posting_id }
    it { should_not allow_mass_assignment_of :state }
  end


  context "#associations" do
    it { should have_one(:order).dependent(:nullify) }
    it { should belong_to :posting }
    it { should belong_to :inventory_item }
  end


  context "#validations" do
    it { should validate_presence_of :posting }
    it { should validate_presence_of :inventory_item }

    it { should ensure_inclusion_of(:state).in_array(['pending', 'declined', 'accepted']) }
    it { should validate_numericality_of(:price) }
    it { should_not allow_value(0).for(:price) } # > 0
    it { should_not allow_value(-1).for(:price) } # > 0
  end


  context "#default_values" do
    its(:state){ should eq 'pending' }
  end


  context "#state_transition" do
    subject { FactoryGirl.create :offer }

    describe "#accept" do
      it "adjusts the state to accepted" do
        expect {
          subject.accept
        }.to change(subject, :state).to(Offer::STATE_ACCEPTED)
      end

      it "declines other offers for the same posting" do
        other_offer = FactoryGirl.create :offer, :posting => subject.posting
        subject.accept
        other_offer.reload.state.should eq Offer::STATE_DECLINED
      end

      it "decrements the inventory item's quantity by 1" do
        InventoryItem.any_instance.should_receive(:decrement_quantity)
        subject.accept
      end

      it "notifies the posting that a purchase is pending" do
        Posting.any_instance.should_receive(:purchase_pending)
        subject.accept
      end
    end

    describe "#decline" do
      it "adjusts the state to declined" do
        expect {
          subject.decline
        }.to change(subject, :state).to(Offer::STATE_DECLINED)
      end
    end

    describe "#unaccept" do
      subject { FactoryGirl.create :offer, :accepted }

      it "adjusts the state to pending" do
        expect {
          subject.unaccept
        }.to change(subject, :state).to(Offer::STATE_PENDING)
      end

      it "undeclines other offers for the same posting" do
        other_offer = FactoryGirl.create :offer, :posting => subject.posting
        subject.unaccept
        other_offer.reload.state.should eq Offer::STATE_PENDING
      end

      it "notifies the posting that the purchase was cancelled" do
        Posting.any_instance.should_receive(:purchase_cancelled)
        subject.unaccept
      end
    end

    describe "#undecline" do
      subject { FactoryGirl.create :offer, :declined }

      it "adjusts the state to pending" do
        expect {
          subject.undecline
        }.to change(subject, :state).to(Offer::STATE_PENDING)
      end
    end

  end

end
