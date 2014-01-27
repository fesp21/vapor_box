class AddNameAndTokenToUsers < ActiveRecord::Migration
  def change
     add_column :subscriptions, :customer_stripe, :string
     add_column :subscriptions, :ship_date, :string
     add_column :users, :first_name, :string
     add_column :users, :last_name, :string


  end
end
