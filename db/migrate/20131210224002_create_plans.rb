class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.integer :cost
      t.string :image

      t.timestamps
    end
  end
end
