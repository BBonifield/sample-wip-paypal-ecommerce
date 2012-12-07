require 'spec_helper'

describe AddressesController do

  it_should_require_login_for_actions :index, :new, :create, :edit, :update, :destroy

  before { login_user }

  describe "GET :index" do
    it "returns http success" do
      get :index
      response.should be_success
    end
    it "assigns all of the user's addresses" do
      FactoryGirl.create :address, :user => current_user
      get :index
      assigns(:addresses).should eq current_user.addresses
    end
  end


  describe "GET :new" do
    it "returns http success" do
      get :new
      response.should be_success
    end
    it "assigns a new address" do
      get :new
      assigns(:address).should be_a_new Address
    end
  end

  describe "POST :create" do
    context "given invalid params" do
      it "assigns the unsaved address" do
        post :create
        assigns(:address).should be_a_new Address
      end
      it "re-renders the new template" do
        post :create
        response.should render_template :new
      end
    end

    context "given valid params" do
      let(:valid_params) {
        { :address => FactoryGirl.attributes_for(:mass_assignable_address) }
      }

      it "creates a new user address" do
        expect {
          post :create, valid_params
        }.to change(Address, :count).by(1)
        Address.last.user.should eq current_user
      end
      it "redirects to the address book" do
        post :create, valid_params
        response.should redirect_to addresses_path
      end
      it "adds a success message" do
        post :create, valid_params
        flash[:notice].should eq 'Address has been created.'
      end
    end
  end


  let(:address_for_current_user) { FactoryGirl.create(:address, :user => current_user) }
  let(:address_for_different_user) { FactoryGirl.create(:address) }

  describe "GET :edit" do
    it "returns http success" do
      get :edit, :id => address_for_current_user.id
      response.should be_success
    end
    it "assigns the requested address" do
      get :edit, :id => address_for_current_user.id
      assigns(:address).should eq address_for_current_user
    end

    context "given another users address" do
      it "renders a 404" do
        get :edit, :id => address_for_different_user.id
        response.response_code.should eq 404
      end
    end
  end

  describe "PUT :update" do
    context "given invalid params" do
      before { Address.any_instance.stub(:save).and_return(false) }

      it "assigns the un-updated address" do
        put :update, :id => address_for_current_user.id
        assigns(:address).should be_an_instance_of Address
      end
      it "re-renders the edit template" do
        put :update, :id => address_for_current_user.id
        response.should render_template :edit
      end
    end

    context "given valid params" do
      let(:valid_params) {
        {
          :id => address_for_current_user.id,
          :address => FactoryGirl.attributes_for(:mass_assignable_address)
        }
      }

      it "updates the address" do
        expect {
          put :update, valid_params
        }.to change{ address_for_current_user.reload.name }
      end
      it "redirects to the address book" do
        put :update, valid_params
        response.should redirect_to addresses_path
      end
      it "adds a success message" do
        put :update, valid_params
        flash[:notice].should eq 'Address has been updated.'
      end
    end

    context "given another users address" do
      it "renders a 404" do
        put :update, :id => address_for_different_user.id
        response.response_code.should eq 404
      end
    end
  end

  describe "DELETE :destroy" do
    it "deletes the address" do
      # pull out id before expect since Rspec let block
      # create an address
      id = address_for_current_user.id
      expect {
        delete :destroy, :id => id
      }.to change(Address, :count).by(-1)
    end
    it "redirects to the address book" do
      delete :destroy, :id => address_for_current_user.id
      response.should redirect_to addresses_path
    end
    it "adds a success message" do
      delete :destroy, :id => address_for_current_user.id
      flash[:notice].should eq 'Address has been deleted.'
    end

    context "given another users address" do
      it "renders a 404" do
        delete :destroy, :id => address_for_different_user.id
        response.response_code.should eq 404
      end
    end
  end

end
