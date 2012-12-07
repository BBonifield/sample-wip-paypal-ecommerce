class AddStatusToIpnNotifications < ActiveRecord::Migration
  def change
    add_column :ipn_notifications, :status, :string
  end
end
