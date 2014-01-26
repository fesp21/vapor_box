class Accessory < ActiveRecord::Base
  attr_accessible :cost, :image, :name, :description

  has_many :accessories_subscriptions
  has_many :subscriptions, through: :accessories_subscriptions

  has_many :one_time_accessories
end
