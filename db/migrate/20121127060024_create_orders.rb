class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :shipping_address_id
      t.integer :billing_address_id
      t.string :state, :default => 'new'
      t.string :paypal_pay_key

      t.timestamps
    end
  end
end
