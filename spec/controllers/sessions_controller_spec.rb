require 'spec_helper'

describe SessionsController do

  describe "GET 'new'" do
    it_should_require_logged_out_for_action :new

    it "renders successfully" do
      get :new
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it_should_require_logged_out_for_action :create

    context "with valid params" do
      let(:known_password) { "somePassword1!" }
      let(:existing_user) { FactoryGirl.create(:user, :password => known_password) }

      # users can login using both email and user_name
      [ :user_name, :email ].each do |user_name_field|

        context "using #{user_name_field} as the user name field" do
          let(:valid_params) {
            user_name_or_email = existing_user.send(user_name_field)
            { :user_name_or_email => user_name_or_email, :password => known_password }
          }

          it "logs the user in" do
            expect {
              post :create, valid_params
            }.to change( @controller, :current_user ).to( existing_user )
          end
          it "redirects to the root path" do
            post :create, valid_params
            response.should redirect_to root_path
          end
          it "adds a success notice" do
            post :create, valid_params
            flash[:notice].should eq "You are now logged in."
          end
        end

      end
    end

    context "with invalid params" do
      it "rerenders the new template" do
        post :create
        response.should render_template :new
      end
      it "assigns the login_failed variable" do
        post :create
        assigns(:login_failed).should eq true
      end
    end
  end

  describe "GET 'destroy'" do
    it_should_require_login_for_action :destroy
    before { login_user }

    it "logs the user out" do
      expect {
        get :destroy
      }.to change( @controller, :current_user ).from(@current_user).to(false)
    end
    it "redirects to the root path" do
      get :destroy
      response.should redirect_to root_path
    end
    it "adds a success notice" do
      get :destroy
      flash[:notice].should eq "You are now logged out."
    end
  end

end
