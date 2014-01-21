class CreateOneTimeAccessoriesTable < ActiveRecord::Migration
  def change
    create_table :one_time_accessories do |t|
      t.integer :subscription_id
      t.integer :accessory_id
      t.integer :amount
      t.timestamps
    end
    create_table :subscription_charges do |t|
      t.integer :subscription_id
      t.integer :amount
      t.string :description
      t.timestamps
    end
  end

end
