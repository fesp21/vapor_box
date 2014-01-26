# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140121014526) do

  create_table "accessories", :force => true do |t|
    t.string   "name"
    t.integer  "cost"
    t.string   "image"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "description"
  end

  create_table "accessories_subscriptions", :id => false, :force => true do |t|
    t.integer "accessory_id"
    t.integer "subscription_id"
    t.integer "quantity"
  end

  create_table "addresses", :force => true do |t|
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "subscription_id"
    t.integer  "user_id"
    t.string   "ship_address1"
    t.string   "ship_address2"
    t.string   "ship_city"
    t.string   "ship_zip"
    t.string   "ship_state"
  end

  add_index "addresses", ["subscription_id"], :name => "index_addresses_on_subscription_id"
  add_index "addresses", ["user_id"], :name => "index_addresses_on_user_id"

  create_table "flavors", :force => true do |t|
    t.string   "name"
    t.string   "level"
    t.string   "image"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "description"
  end

  create_table "flavors_subscriptions", :id => false, :force => true do |t|
    t.integer "flavor_id"
    t.integer "subscription_id"
    t.integer "quantity"
  end

  create_table "one_time_accessories", :force => true do |t|
    t.integer  "subscription_id"
    t.integer  "accessory_id"
    t.integer  "quantity"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "plan_subscriptions", :id => false, :force => true do |t|
    t.integer "plan_id"
    t.integer "subscription_id"
    t.integer "quantity"
  end

  create_table "plans", :force => true do |t|
    t.string   "name"
    t.integer  "cost"
    t.string   "image"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "flavor_count"
    t.string   "description"
  end

  create_table "subscription_charges", :force => true do |t|
    t.integer  "subscription_id"
    t.integer  "amount"
    t.string   "description"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "cost"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
    t.integer  "address_id"
    t.string   "token"
    t.string   "ship_date"
  end

  add_index "subscriptions", ["address_id"], :name => "index_subscriptions_on_address_id"
  add_index "subscriptions", ["user_id"], :name => "index_subscriptions_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
