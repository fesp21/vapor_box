class FlavorsSubscription < ActiveRecord::Base
  attr_accessible :flavor_id, :subscription_id
  belongs_to :flavor
  belongs_to :subscription
end