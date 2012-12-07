class AddOfferIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :offer_id, :integer
  end
end
