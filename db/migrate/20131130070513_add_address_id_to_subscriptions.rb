class AddAddressIdToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :address_id, :integer
    add_index :subscriptions, :address_id
  end
end
