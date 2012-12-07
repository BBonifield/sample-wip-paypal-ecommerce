require 'spec_helper'

describe InventoryGroup do

  context "#mass_assignment" do
    it { should allow_mass_assignment_of :name }
    it { should_not allow_mass_assignment_of :user_id }
  end


  context "#associations" do
    it { should belong_to :user }
    it { should have_many(:inventory_items).dependent(:nullify) }
  end


  context "#validations" do
    it { should validate_presence_of :name }
  end

end
