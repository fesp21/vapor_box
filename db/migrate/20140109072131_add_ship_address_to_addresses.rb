class AddShipAddressToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :ship_address1, :string
    add_column :addresses, :ship_address2, :string
    add_column :addresses, :ship_city, :string
    add_column :addresses, :ship_zip, :string
    add_column :addresses, :ship_state, :string
  end
end
