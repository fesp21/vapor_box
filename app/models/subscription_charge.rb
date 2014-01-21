class SubscriptionCharge < ActiveRecord::Base
  attr_accessible :subscription_id, :amount, :description
  belongs_to :subscription
  
end
