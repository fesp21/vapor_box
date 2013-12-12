class AcessoriesSubscriptionsJoinTable < ActiveRecord::Migration
  def change
    create_table :accesories_subscriptions, :id => false do |t|
    t.integer :accesory_id
    t.integer :subscription_id
    t.integer :quantity
    end
  end
end
