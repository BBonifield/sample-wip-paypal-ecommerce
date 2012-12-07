require 'spec_helper'

describe PaypalController do

  it_should_require_logged_out_for_action :ipn_notification

  describe "POST :ipn_notification" do
    let(:required_params) {
      { :pay_key => 'paypal_pay_key', :transaction => { 'asdf' => 1234 } }
    }

    it "returns http success" do
      post :ipn_notification, required_params
      response.should be_success
    end
    it "creates the ipn notification" do
      expect {
        post :ipn_notification, required_params
      }.to change(IpnNotification, :count).by(1)

      notification = IpnNotification.last
      notification.raw_post.should eq request.raw_post
      notification.paypal_pay_key.should eq required_params[:pay_key]
      notification.status.should eq required_params[:status]
    end
  end
end
