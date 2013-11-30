class CreateJoinTableItemSubscription < ActiveRecord::Migration
  create_table :items_subscriptions, :id => false do |t|
    t.integer :item_id
    t.integer :subscription_id
  end
end
