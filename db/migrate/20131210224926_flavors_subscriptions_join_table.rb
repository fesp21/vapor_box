class FlavorsSubscriptionsJoinTable < ActiveRecord::Migration
  def change
    create_table :flavors_subscriptions, :id => false do |t|
    t.integer :flavor_id
    t.integer :subscription_id
    t.integer :quantity
    end
  end
end
