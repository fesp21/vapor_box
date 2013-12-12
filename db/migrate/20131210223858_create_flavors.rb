class CreateFlavors < ActiveRecord::Migration
  def change
    create_table :flavors do |t|
      t.string :name
      t.string :level
      t.string :image

      t.timestamps
    end
  end
end
