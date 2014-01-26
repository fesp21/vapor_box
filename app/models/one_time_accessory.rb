class OneTimeAccessory < ActiveRecord::Base
  
  attr_accessible :subscription_id, :quantity, :accessory_id
  has_one :subscription
  has_one :accessory
  
end
