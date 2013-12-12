class Flavor < ActiveRecord::Base
  attr_accessible :cost, :image, :level, :name
  belongs_to :subscription
end
