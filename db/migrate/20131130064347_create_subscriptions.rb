class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.decimal :cost, :precision => 8, :scale => 2


      t.timestamps
    end
  end
end
