class AddDefaultValuesToAddressBooleans < ActiveRecord::Migration
  def up
    change_column :addresses, :is_default_shipping, :boolean, :default => false
    change_column :addresses, :is_default_billing, :boolean, :default => false
  end

  def down
    change_column :addresses, :is_default_shipping, :boolean
    change_column :addresses, :is_default_billing, :boolean
  end
end
