class AcessoriesSubscriptionsJoinTable < ActiveRecord::Migration
  def change
    create_table :accessories_subscriptions, :id => false do |t|
    t.integer :accessory_id
    t.integer :subscription_id
    t.integer :quantity
    end
  end
end
