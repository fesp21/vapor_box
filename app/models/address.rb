class Address < ActiveRecord::Base
  attr_accessible :address1, :address2, :city, :state, :subscription_id, :user_id, :zip, :ship_address1, :ship_address2, :ship_city, :ship_state, :ship_zip
  belongs_to :subscription
  belongs_to :user

end
