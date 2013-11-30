class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :level
      t.string :type
      t.integer :quantity
      t.decimal :cost, :precision => 8, :scale => 2

      t.timestamps
    end
  end
end
