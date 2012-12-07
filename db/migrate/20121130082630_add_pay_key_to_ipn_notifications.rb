class AddPayKeyToIpnNotifications < ActiveRecord::Migration
  def change
    add_column :ipn_notifications, :paypal_pay_key, :string
  end
end
