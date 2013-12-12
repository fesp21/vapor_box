class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.decimal :cost, :precision => 8, :scale => 2
      t.string :image

      t.timestamps
    end
  end
end
