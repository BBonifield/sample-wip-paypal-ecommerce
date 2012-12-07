require 'spec_helper'

describe User do

  context "#attributes" do
    it { should respond_to :is_signing_up }
    it { should respond_to :is_signing_up= }
  end


  context "#mass_assignment" do
    it { should allow_mass_assignment_of :user_name }
    it { should allow_mass_assignment_of :email }
    it { should allow_mass_assignment_of :password }
    it { should allow_mass_assignment_of :password_confirmation }
    it { should allow_mass_assignment_of :first_name }
    it { should allow_mass_assignment_of :last_name }
    it { should allow_mass_assignment_of :addresses_attributes }

    it { should_not allow_mass_assignment_of :is_signing_up }
  end


  context "#associations" do
    it { should have_many(:addresses).dependent(:destroy) }
    it { should accept_nested_attributes_for(:addresses).limit(1) }
    it { should have_many(:inventory_items).dependent(:destroy) }
    it { should have_many(:postings).dependent(:destroy) }
    it { should have_many(:inventory_groups).dependent(:destroy) }
  end


  context "#validations" do
    include UserModelMacros

    it { should validate_presence_of :user_name }
    it { should validate_uniqueness_of :user_name }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }

    it { should validate_presence_of :password }
    it { should validate_confirmation_of :password }

    it_should_validate_presence_of_an_address_at_signup
  end

  describe "#full_name" do
    let(:user) { FactoryGirl.build(:user) }
    subject{ user.full_name }

    it { should eq "#{user.first_name} #{user.last_name}" }
  end
end
