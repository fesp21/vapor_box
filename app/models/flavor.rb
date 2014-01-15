class Flavor < ActiveRecord::Base
  attr_accessible :cost, :image, :level, :name, :description
  belongs_to :subscription
end
