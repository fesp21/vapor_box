class AddressToAddress1 < ActiveRecord::Migration
  def change
    rename_column :addresses, :address, :address1
  end

end
