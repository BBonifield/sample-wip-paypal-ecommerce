require 'spec_helper'

describe ShippingNotification do

  context "#attributes" do
    it { should respond_to :tracking_number }
    it { should respond_to :shipping_service_id }
    it { should respond_to :order_id }
    it { should respond_to :note }
  end


  context "#assocation_getters" do
    let(:order) { FactoryGirl.create :order }
    let(:shipping_service) { FactoryGirl.create :shipping_service }

    describe "#order" do
      it "returns nil if no order_id is specified" do
        notification = ShippingNotification.new
        notification.order.should be_nil
      end
      it "returns nil if an invalid order_id is specified" do
        notification = ShippingNotification.new :order_id => 1234
        notification.order.should be_nil
      end
      it "returns the order if a valid order_id is specified" do
        notification = ShippingNotification.new :order_id => order.id
        notification.order.should eq order
      end
    end

    describe "#shipping_service" do
      it "returns nil if no shipping_service_id is specified" do
        notification = ShippingNotification.new
        notification.shipping_service.should be_nil
      end
      it "returns nil if an invalid shipping_service_id is specified" do
        notification = ShippingNotification.new :shipping_service_id => 1234
        notification.shipping_service.should be_nil
      end
      it "returns the shipping_service if a valid shipping_service_id is specified" do
        notification = ShippingNotification.new :shipping_service_id => shipping_service.id
        notification.shipping_service.should eq shipping_service
      end
    end

  end


  context "#initialization" do
    let(:tracking_number) { '12345' }
    let(:note) { 'asdf' }
    let(:attributes) {
      { :tracking_number => tracking_number, :note => note }
    }

    it "can extract attributes" do
      notification = ShippingNotification.new attributes
      notification.tracking_number.should eq tracking_number
      notification.note.should eq note
    end
    it "does not error if nil is passed through" do
      expect {
        ShippingNotification.new nil
      }.to_not raise_error
    end
  end


  context "#validations" do
    it { should validate_presence_of :tracking_number }
    it { should validate_presence_of :shipping_service_id }
    it { should validate_presence_of :order_id }
  end


  describe "#send_notification" do
    let(:invalid_notification) { ShippingNotification.new }
    let(:valid_notification) { FactoryGirl.build :shipping_notification }

    it "returns false if the notification is invalid" do
      invalid_notification.should_not be_valid
      invalid_notification.send_notification.should eq false
    end
    it "returns true if the notification is valid" do
      valid_notification.should be_valid
      valid_notification.send_notification.should eq true
    end

    context "#email_sending" do
      it "does not send the email if the notification is invalid" do
        ApplicationMailer.should_not_receive(:shipping_notification_for_buyer)
        invalid_notification.send_notification
      end

      it "sends the email if the notification is valid" do
        message = double("Mail::Message")

        # creates the email, sends the notification as the arguments
        ApplicationMailer.should_receive(:shipping_notification_for_buyer).
          with(valid_notification).and_return(message)

        # actually delivers the built message
        message.should_receive(:deliver).and_return(true)

        valid_notification.send_notification
      end
    end
  end

end
