require 'spec_helper'

describe UsersController do

  describe "GET 'new'" do
    it_should_require_logged_out_for_action :new

    it "returns http success" do
      get :new
      response.should be_success
    end
    it "assigns a new user as @user" do
      get :new
      assigns(:user).should be_a_new User
    end
    it "builds a nested address record for the user" do
      get :new
      assigns(:user).addresses.length.should eq 1
    end
  end

  describe "POST 'create'" do
    it_should_require_logged_out_for_action :create

    it "defines that the user is signing up" do
      post :create
      assigns(:user).is_signing_up.should eq true
    end

    context "with invalid params" do
      it "re-renders the new template" do
        post :create
        response.should render_template :new
      end
      it "assigns a new user as @user" do
        post :create
        assigns(:user).should be_a_new User
      end
    end

    context "with valid params" do
      let(:valid_params) {
        { :user => FactoryGirl.attributes_for(:mass_assignable_user) }
      }

      it "redirects to the root path" do
        post :create, valid_params
        response.should redirect_to root_path
      end
      it "creates a new user" do
        expect {
          post :create, valid_params
        }.to change( User, :count ).by(1)
      end
      it "creates a nested address" do
        post :create, valid_params
        assigns(:user).addresses.length.should eq 1
      end
      it "sets defaults on the nested address" do
        post :create, valid_params
        address = assigns(:user).addresses.first
        address.name.should eq "Primary Address"
        address.is_default_billing.should be_true
        address.is_default_shipping.should be_true
      end
      it "logs the new user in" do
        post :create, valid_params
        @controller.current_user.should eq User.last
      end
      it "adds a success notice" do
        post :create, valid_params
        flash[:notice].should eq "Your account has been created!"
      end
    end

  end

end
