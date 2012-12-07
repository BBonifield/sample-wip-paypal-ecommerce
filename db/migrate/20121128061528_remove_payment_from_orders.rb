class RemovePaymentFromOrders < ActiveRecord::Migration
  def up
    remove_column :orders, :paypal_pay_key
  end

  def down
    add_column :orders, :paypal_pay_key, :string
  end
end
