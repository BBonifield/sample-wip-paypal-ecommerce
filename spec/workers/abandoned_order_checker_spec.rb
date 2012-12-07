require 'spec_helper'

describe AbandonedOrderChecker do
  let(:order) { FactoryGirl.create :order }

  before {
    Order.stub(:find).
      with(order.id).
      and_return(order)
  }

  describe "given a new order" do
    it "marks the order as abandoned" do
      order.should_receive(:purchase_abandoned)

      AbandonedOrderChecker.perform order.id
    end
  end
end
