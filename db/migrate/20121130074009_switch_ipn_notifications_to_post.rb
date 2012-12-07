class SwitchIpnNotificationsToPost < ActiveRecord::Migration
  def up
    remove_column :ipn_notifications, :serialized_transaction
    add_column :ipn_notifications, :raw_post, :text
  end

  def down
    add_column :ipn_notifications, :serialized_transaction, :binary
    remove_column :ipn_notifications, :raw_post
  end
end
