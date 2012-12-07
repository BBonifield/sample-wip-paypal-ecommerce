class CreateIpnNotifications < ActiveRecord::Migration
  def change
    create_table :ipn_notifications do |t|
      t.binary :serialized_transaction

      t.timestamps
    end
  end
end
