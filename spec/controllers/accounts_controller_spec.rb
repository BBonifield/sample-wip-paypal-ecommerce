require 'spec_helper'

describe AccountsController do

  it_should_require_login_for_actions :show, :edit, :update

  before { login_user }


  describe "GET 'show'" do
    it "returns http success" do
      get 'show'
      response.should be_success
    end
  end


  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit'
      response.should be_success
    end
  end

  describe "PUT 'update'" do

    context "given valid params" do
      let(:valid_params) {
        { :user => FactoryGirl.attributes_for(:mass_assignable_user) }
      }

      it "updates the user's basic details" do
        expect {
          put 'update', valid_params
        }.to change{ current_user.reload.first_name }
      end
      it "redirects to the accounts#show" do
        put 'update', valid_params
        response.should redirect_to account_path
      end
      it "adds a success noticed" do
        put 'update', valid_params
        flash[:notice].should eq "Your account has been updated."
      end

    end

    context "given invalid params" do
      before { User.any_instance.stub(:save).and_return(false) }
      it "re-renders the edit template" do
        put 'update'
        response.should render_template :edit
      end
    end

  end


  describe "GET 'edit_password'" do
    it "returns http success" do
      get 'edit_password'
      response.should be_success
    end
  end

  describe "PUT 'update_password'" do
    let(:existing_password) { "knownPassword1!" }
    let(:new_password) { "newPassword1!" }
    before { login_user( :password => existing_password ) }

    context "given valid params" do
      let(:valid_params) {
        { :old_password => existing_password,
          :user => { :password => new_password, :password_confirmation => new_password } }
      }

      it "update_passwords the user's password" do
        put 'update_password', valid_params
        User.authenticate( current_user.user_name, new_password ).should eq current_user
      end
      it "redirects to the accounts#show" do
        put 'update_password', valid_params
        response.should redirect_to account_path
      end
      it "adds a success noticed" do
        put 'update_password', valid_params
        flash[:notice].should eq "Your password has been changed."
      end

    end

    context "given the wrong old password" do
      it "re-renders the edit_password template" do
        put 'update_password', :old_password => "somethingWrong1!"
        response.should render_template :edit_password
      end
      it "adds an error message to the flash" do
        put 'update_password', :old_password => "somethingWrong1!"
        flash[:error].should eq "Your old password was incorrect."
      end
    end

    context "given the right old password but invalid new password values" do
      before { User.any_instance.stub(:save).and_return(false) }
      it "re-renders the edit_password template" do
        put 'update_password', :old_password => existing_password
        response.should render_template :edit_password
      end
      it "does not add an error message to the flash" do
        put 'update_password', :old_password => existing_password
        flash[:error].should be_nil
      end
    end

  end

end
