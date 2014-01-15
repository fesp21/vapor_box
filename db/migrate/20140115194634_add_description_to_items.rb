class AddDescriptionToItems < ActiveRecord::Migration
  def change
    add_column :accessories, :description, :string
    add_column :flavors, :description, :string
    add_column :plans, :description, :string
  end
end
