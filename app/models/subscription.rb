class Subscription < ActiveRecord::Base
  attr_accessible :address_id, :cost, :user_id

  has_many :flavors, through: :flavors_subscriptions
  has_many :plans, through: :plans_subscriptions
  has_many :accesories, through: :acessories_subscriptions
  has_many :subscription_charges
  has_many :one_time_accessories
  belongs_to :address
  belongs_to :user
  
end
