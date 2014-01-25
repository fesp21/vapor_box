class PlanSubscriptionsJoinTable < ActiveRecord::Migration
  def change
    create_table :plan_subscriptions, :id => false do |t|
    t.integer :plan_id
    t.integer :subscription_id
    t.integer :quantity
    end
  end
end
