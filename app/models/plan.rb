class Plan < ActiveRecord::Base
  attr_accessible :cost, :image, :name, :description, :flavor_count

  has_many :subscriptions, through: :plan_subscriptions
  has_many :plan_subscriptions
end
