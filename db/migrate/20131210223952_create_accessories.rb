class CreateAccessories < ActiveRecord::Migration
  def change
    create_table :accessories do |t|
      t.string :name
      t.integer :cost
      t.string :image

      t.timestamps
    end
  end
end
