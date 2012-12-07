class AddSerializedResponseToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :serialized_response, :binary
  end
end
