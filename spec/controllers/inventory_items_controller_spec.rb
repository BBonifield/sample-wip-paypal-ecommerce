require 'spec_helper'

describe InventoryItemsController do

  it_should_require_login_for_actions :index,
    :new, :create,
    :edit, :update,
    :destroy

  before { login_user }

  describe "GET :index" do
    it "returns http success" do
      get :index
      response.should be_success
    end
    it "assigns the user's inventory items" do
      FactoryGirl.create :inventory_item, :user => current_user
      FactoryGirl.create :inventory_item # another user's item
      get :index
      assigns(:inventory_items).should eq current_user.inventory_items
    end

    context "when filtering by an inventory group" do
      it "only includes items in that inventory group" do
        filter_group = FactoryGirl.create :inventory_group, :user => current_user
        item_in_filter_group = FactoryGirl.create :inventory_item, :user => current_user, :inventory_group => filter_group

        other_group = FactoryGirl.create :inventory_group, :user => current_user
        item_in_other_group = FactoryGirl.create :inventory_item, :user => current_user, :inventory_group => other_group

        get :index, :inventory_group_id => filter_group.id
        assigns(:inventory_items).should eq [item_in_filter_group]
      end
      it "assigns the inventory group" do
        filter_group = FactoryGirl.create :inventory_group, :user => current_user
        get :index, :inventory_group_id => filter_group.id
        assigns(:inventory_group).should eq filter_group
      end
    end
  end

  describe "GET :pending_delivery", :focus do
    it "returns http success" do
      get :pending_delivery
      response.should be_success
    end

    it "assigns the user's pending inventory items" do
      pending_item = FactoryGirl.create :inventory_item, :pending_delivery, :user => current_user
      non_pending_item = FactoryGirl.create :inventory_item, :user => current_user
      non_user_item = FactoryGirl.create :inventory_item

      get :pending_delivery
      assigns(:inventory_items).should eq [ pending_item ]
    end
  end

  describe "GET :new" do
    it "returns http success" do
      get :new
      response.should be_success
    end
    it "assigns a new inventory item" do
      get :new
      assigns(:inventory_item).should be_a_new InventoryItem
    end
  end

  describe "POST :create" do
    context "given invalid params" do
      it "assigns the unsaved inventory_item" do
        post :create
        assigns(:inventory_item).should be_a_new InventoryItem
      end
      it "re-renders the new template" do
        post :create
        response.should render_template :new
      end
    end

    context "given valid params" do
      let(:valid_params) {
        item_params = FactoryGirl.attributes_for(:mass_assignable_inventory_item)
        item_params[:inventory_image] = fixture_file_upload("files/test_image.jpg", 'image/jpeg')
        { :inventory_item => item_params }
      }

      it "creates a new user inventory_item" do
        expect {
          post :create, valid_params
        }.to change(InventoryItem, :count).by(1)
        InventoryItem.last.user.should eq current_user
      end
      it "redirects to the inventory list" do
        post :create, valid_params
        response.should redirect_to inventory_items_path
      end
      it "adds a success message" do
        post :create, valid_params
        flash[:notice].should eq 'Inventory item has been created.'
      end
    end
  end


  let(:inventory_item_for_current_user) { FactoryGirl.create(:inventory_item, :user => current_user) }
  let(:inventory_item_for_different_user) { FactoryGirl.create(:inventory_item) }


  describe "GET :edit" do
    it "returns http success" do
      get :edit, :id => inventory_item_for_current_user.id
      response.should be_success
    end
    it "assigns the requested inventory_item" do
      get :edit, :id => inventory_item_for_current_user.id
      assigns(:inventory_item).should eq inventory_item_for_current_user
    end

    context "given another users inventory_item" do
      it "renders a 404" do
        get :edit, :id => inventory_item_for_different_user.id
        response.response_code.should eq 404
      end
    end
  end

  describe "PUT :update" do
    context "given invalid params" do
      before { InventoryItem.any_instance.stub(:save).and_return(false) }

      it "assigns the un-updated inventory_item" do
        put :update, :id => inventory_item_for_current_user.id
        assigns(:inventory_item).should be_an_instance_of InventoryItem
      end
      it "re-renders the edit template" do
        put :update, :id => inventory_item_for_current_user.id
        response.should render_template :edit
      end
    end

    context "given valid params" do
      let(:valid_params) {
        {
          :id => inventory_item_for_current_user.id,
          :inventory_item => FactoryGirl.attributes_for(:mass_assignable_inventory_item)
        }
      }

      it "updates the inventory_item" do
        expect {
          put :update, valid_params
        }.to change{ inventory_item_for_current_user.reload.name }
      end
      it "redirects to the inventory list" do
        put :update, valid_params
        response.should redirect_to inventory_items_path
      end
      it "adds a success message" do
        put :update, valid_params
        flash[:notice].should eq 'Inventory item has been updated.'
      end
    end

    context "given another users inventory_item" do
      it "renders a 404" do
        put :update, :id => inventory_item_for_different_user.id
        response.response_code.should eq 404
      end
    end
  end

  describe "DELETE :destroy" do
    it "deletes the inventory_item" do
      # pull out id before expect since Rspec let block
      # create an InventoryItem
      id = inventory_item_for_current_user.id
      expect {
        delete :destroy, :id => id
      }.to change(InventoryItem, :count).by(-1)
    end
    it "redirects to the inventory list" do
      delete :destroy, :id => inventory_item_for_current_user.id
      response.should redirect_to inventory_items_path
    end
    it "adds a success message" do
      delete :destroy, :id => inventory_item_for_current_user.id
      flash[:notice].should eq 'Inventory item has been deleted.'
    end

    context "given another users inventory_item" do
      it "renders a 404" do
        delete :destroy, :id => inventory_item_for_different_user.id
        response.response_code.should eq 404
      end
    end
  end

  describe "POST :increment_quantity" do
    it "increments the inventory_item" do
      InventoryItem.any_instance.
        should_receive(:increment_quantity).
        and_return(true)
      post :increment_quantity, :id => inventory_item_for_current_user.id
    end
    it "returns the new inventory in the return json" do
      post :increment_quantity, :id => inventory_item_for_current_user.id
      new_quantity = inventory_item_for_current_user.reload.quantity
      JSON.parse(response.body)['new_quantity'].should eq new_quantity
    end
  end

  describe "POST :decrement_quantity" do
    it "decrements the inventory_item" do
      InventoryItem.any_instance.
        should_receive(:decrement_quantity).
        and_return(true)
      post :decrement_quantity, :id => inventory_item_for_current_user.id
    end
    it "returns the new inventory in the return json" do
      post :decrement_quantity, :id => inventory_item_for_current_user.id
      new_quantity = inventory_item_for_current_user.reload.quantity
      JSON.parse(response.body)['new_quantity'].should eq new_quantity
    end
  end

end
