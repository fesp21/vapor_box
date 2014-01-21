class Plan < ActiveRecord::Base
  attr_accessible :cost, :image, :name, :description, :flavor_count

  belongs_to :subscription
end
