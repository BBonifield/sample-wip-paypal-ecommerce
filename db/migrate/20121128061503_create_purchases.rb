class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :order_id
      t.decimal :amount
      t.decimal :seller_amount
      t.decimal :fee_amount
      t.string :paypal_pay_key

      t.timestamps
    end
  end
end
