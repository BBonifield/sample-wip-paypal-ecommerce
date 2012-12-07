class AddLogoIdentierToShippingServices < ActiveRecord::Migration
  def change
    add_column :shipping_services, :logo_identifier, :string
  end
end
