class Address < ActiveRecord::Base
  attr_accessible :address, :address2, :city, :state, :subscription_id, :user_id, :zip

  belongs_to :subscription
  belongs_to :user

end
