require 'spec_helper'

describe InventoryGroupsController do

  it_should_require_login_for_action :create

  before { login_user }

  describe "POST 'create'" do
    context "with invalid params" do
      before { InventoryGroup.any_instance.stub(:save).and_return(false) }

      it "returns http error" do
        post 'create'
        response.status.should eq 400
      end
    end

    context "with valid params" do
      let(:valid_params) {
        { :format => 'json',
          :inventory_group => FactoryGirl.attributes_for(:mass_assignable_inventory_group) }
      }

      it "returns http success" do
        post 'create', valid_params
        response.should be_success
      end

      it "creates a new inventory group for the logged in user" do
        expect {
          post 'create', valid_params
        }.to change(InventoryGroup, :count).by(1)
        InventoryGroup.last.user.should eq current_user
      end
    end
  end

end
