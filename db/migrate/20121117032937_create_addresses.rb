class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :name
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip_code
      t.integer :user_id
      t.boolean :is_default_shipping
      t.boolean :is_default_billing

      t.timestamps
    end
  end
end
