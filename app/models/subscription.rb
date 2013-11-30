class Subscription < ActiveRecord::Base
  attr_accessible :address_id, :cost, :user_id

  has_and_belongs_to_many :items
  belongs_to :address
  belongs_to :user
  
end
