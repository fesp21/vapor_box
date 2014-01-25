class Flavor < ActiveRecord::Base
  attr_accessible :cost, :image, :level, :name, :description
  
  has_many :subscriptions, through: :flavors_subscriptions
  has_many :flavors_subscriptions
end
