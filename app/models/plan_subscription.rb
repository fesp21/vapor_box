class PlanSubscription < ActiveRecord::Base
  attr_accessible :plan_id, :subscription_id
  belongs_to :plan
  belongs_to :subscription
end