require 'spec_helper'

describe InventoryItem do

  context "#mass_assignment" do
    it { should allow_mass_assignment_of :category_id }
    it { should allow_mass_assignment_of :condition_id }
    it { should allow_mass_assignment_of :shipping_speed_id }
    it { should allow_mass_assignment_of :inventory_group_id }
    it { should allow_mass_assignment_of :name }
    it { should allow_mass_assignment_of :details }
    it { should allow_mass_assignment_of :quantity }
    it { should allow_mass_assignment_of :shipping_cost }
    it { should allow_mass_assignment_of :keyword_1 }
    it { should allow_mass_assignment_of :keyword_2 }
    it { should allow_mass_assignment_of :keyword_3 }
    it { should allow_mass_assignment_of :keyword_4 }
    it { should allow_mass_assignment_of :keyword_5 }
    it { should allow_mass_assignment_of :keyword_6 }
    it { should allow_mass_assignment_of :inventory_image }
    it { should allow_mass_assignment_of :inventory_image_cache }

    it { should_not allow_mass_assignment_of :user_id }
  end


  context "#associations" do
    it { should belong_to :user }
    it { should belong_to :category }
    it { should belong_to :condition }
    it { should belong_to :shipping_speed }
    it { should belong_to :inventory_group }
    it { should have_many(:offers).dependent(:destroy) }
  end


  context "#validations" do
    it { should validate_presence_of :user }
    it { should validate_presence_of :category }
    it { should validate_presence_of :condition }
    it { should validate_presence_of :shipping_speed }

    it { should validate_presence_of :name }
    it { should validate_presence_of :details }
    it { should validate_presence_of :inventory_image }

    it { should validate_numericality_of(:quantity).only_integer }
    it { should_not allow_value(0).for(:quantity) } # > 0
    it { should_not allow_value(-1).for(:quantity) } # > 0
    it { should validate_numericality_of(:shipping_cost) }
    it { should_not allow_value(0).for(:shipping_cost) } # > 0
    it { should_not allow_value(-1).for(:shipping_cost) } # > 0
  end


  context "#scopes" do
    describe "#pending_delivery" do
      it "only includes inventory items that are pending delivery" do
      pending_item = FactoryGirl.create :inventory_item, :pending_delivery
      shipped_item = FactoryGirl.create :inventory_item, :shipped

      InventoryItem.pending_delivery.should eq [ pending_item ]
      end
    end
  end


  context "#quantity_management" do
    before { subject.quantity = 2 }

    describe "#decrement_quantity" do
      it "decreases the quantity by 1" do
        expect {
          subject.decrement_quantity
        }.to change(subject, :quantity).by(-1)
      end
    end
    describe "#increment_quantity" do
      it "increases the quantity by 1" do
        expect {
          subject.increment_quantity
        }.to change(subject, :quantity).by(1)
      end
    end
  end
end
