class PlansSubscriptionsJoinTable < ActiveRecord::Migration
  def change
    create_table :plans_subscriptions, :id => false do |t|
    t.integer :plan_id
    t.integer :subscription_id
    t.integer :quantity
    end
  end
end
