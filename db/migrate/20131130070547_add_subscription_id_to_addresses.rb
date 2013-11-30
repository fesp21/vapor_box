class AddSubscriptionIdToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :subscription_id, :integer
    add_index :addresses, :subscription_id
  end
end
