class Plan < ActiveRecord::Base
  attr_accessible :cost, :image, :name, :description

  belongs_to :subscription
end
