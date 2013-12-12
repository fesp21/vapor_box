class Accessory < ActiveRecord::Base
  attr_accessible :cost, :image, :name
  belongs_to :subscription
end
