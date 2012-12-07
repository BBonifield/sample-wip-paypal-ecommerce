class AbandonedOrderChecker
  @queue = :default

  def self.perform order_id
    self.new(order_id).work
  end

  def initialize order_id
    @order = Order.find order_id
  end

  def work
    if @order.state == Order::STATE_NEW
      # order has been pending too long, assume the user
      # abanded it during purchase processing
      @order.purchase_abandoned
    end
  end
end
