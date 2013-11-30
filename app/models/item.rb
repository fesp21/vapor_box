class Item < ActiveRecord::Base
  attr_accessible :cost, :level, :name, :quantity, :type

  has_and_belongs_to_many :subscriptions
  
end
