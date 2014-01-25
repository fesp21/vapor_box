class AccessoriesSubscription < ActiveRecord::Base
  attr_accessible :accessory_id, :subscription_id
  belongs_to :accessory
  belongs_to :subscription
end