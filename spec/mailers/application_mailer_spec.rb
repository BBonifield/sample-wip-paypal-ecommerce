require "spec_helper"

describe ApplicationMailer do

  describe "#shipping_notification_for_buyer" do
    let(:notification){ FactoryGirl.build :shipping_notification }
    let(:mail){ ApplicationMailer.shipping_notification_for_buyer(notification) }

    it "gets sent to the buyer" do
      mail.to.should include notification.order.buyer.email
    end
    it "should be a multipart email" do
      mail.multipart?.should == true
    end
    it "should have the proper subject" do
      mail.subject.should eq "Your order has been shipped"
    end
    it "delivers" do
      expect { mail.deliver }.to_not raise_error
    end
  end
end
