class Subscription < ActiveRecord::Base
  attr_accessible :address_id, :cost, :user_id

  has_many :flavors, through: :flavors_subscriptions
  has_many :plans, through: :plans_subscriptions
  has_many :accesories, through: :acessories_subscriptions
  belongs_to :address
  belongs_to :user
  
end
