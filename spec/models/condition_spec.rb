require 'spec_helper'

describe Condition do

  context "#mass_assignment" do
    it { should allow_mass_assignment_of :name }
    it { should allow_mass_assignment_of :sort_order }
  end


  context "#associations" do
    it { should have_many(:inventory_items).dependent(:nullify) }
  end


  context "#default scope" do
    include OrderingMacros
    klass_should_order_by Condition, :sort_order
  end

end
