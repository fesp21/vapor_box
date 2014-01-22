class OneTimeAccessory < ActiveRecord::Base
  attr_accessible :subscription_id, :quantity, :accessory_id
  belongs_to :subscription
  has_one :accessory
  
end
