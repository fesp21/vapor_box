class AddFlavorCountToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :flavor_count, :integer
  end
end
