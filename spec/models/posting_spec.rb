require 'spec_helper'

describe Posting do

  context "#mass_asssignment" do
    it { should allow_mass_assignment_of :name }
    it { should allow_mass_assignment_of :details }
    it { should allow_mass_assignment_of :price }
    it { should allow_mass_assignment_of :posting_image }
    it { should allow_mass_assignment_of :posting_image_cache }
    it { should allow_mass_assignment_of :category_id }
    it { should allow_mass_assignment_of :condition_id }

    it { should_not allow_mass_assignment_of :user_id }
  end


  context "#associations" do
    it { should belong_to :user }
    it { should belong_to :condition }
    it { should belong_to :category }
    it { should have_many(:offers).dependent(:destroy) }
  end


  context "#validations" do
    it { should validate_presence_of :user }
    it { should validate_presence_of :category }
    it { should validate_presence_of :condition }

    it { should validate_presence_of :name }
    it { should validate_presence_of :details }
    it { should validate_presence_of :posting_image }

    it { should validate_numericality_of(:price) }
    it { should_not allow_value(0).for(:price) } # > 0
    it { should_not allow_value(-1).for(:price) } # > 0

    it { should ensure_inclusion_of(:state).in_array(Posting.valid_states) }
  end


  context "#default_values" do
    its(:state){ should eq Posting::STATE_ACTIVE }
  end


  context "#state_transition" do

    describe "#purchase_pending" do
      subject { FactoryGirl.create :posting }
      it "adjusts the state to purchase pending" do
        expect {
          subject.purchase_pending
        }.to change(subject, :state).to(Posting::STATE_PURCHASE_PENDING)
      end
    end
    describe "#purchase_complete" do
      subject { FactoryGirl.create :posting, :purchase_pending }
      it "adjusts the state to purchase complete" do
        expect {
          subject.purchase_complete
        }.to change(subject, :state).to(Posting::STATE_PURCHASE_COMPLETE)
      end
    end
    describe "#purchase_cancelled" do
      subject { FactoryGirl.create :posting, :purchase_pending }
      it "adjusts the state to active" do
        expect {
          subject.purchase_cancelled
        }.to change(subject, :state).to(Posting::STATE_ACTIVE)
      end
    end
  end
end
