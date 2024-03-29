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

ActiveRecord::Schema.define(:version => 20121205075542) do

  create_table "addresses", :force => true do |t|
    t.string   "name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.integer  "user_id"
    t.boolean  "is_default_shipping", :default => false
    t.boolean  "is_default_billing",  :default => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "sort_order"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "conditions", :force => true do |t|
    t.string   "name"
    t.integer  "sort_order"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "inventory_groups", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "inventory_items", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "category_id"
    t.integer  "condition_id"
    t.integer  "quantity"
    t.decimal  "shipping_cost"
    t.integer  "shipping_speed_id"
    t.text     "details"
    t.string   "keyword_1"
    t.string   "keyword_2"
    t.string   "keyword_3"
    t.string   "keyword_4"
    t.string   "keyword_5"
    t.string   "keyword_6"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "inventory_image"
    t.integer  "inventory_group_id"
  end

  create_table "ipn_notifications", :force => true do |t|
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.text     "raw_post"
    t.string   "paypal_pay_key"
    t.string   "status"
  end

  create_table "offers", :force => true do |t|
    t.integer  "posting_id"
    t.integer  "inventory_item_id"
    t.decimal  "price"
    t.string   "state",             :default => "pending"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  create_table "orders", :force => true do |t|
    t.integer  "shipping_address_id"
    t.integer  "billing_address_id"
    t.string   "state",               :default => "new"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "offer_id"
  end

  create_table "postings", :force => true do |t|
    t.string   "name"
    t.string   "details"
    t.decimal  "price"
    t.integer  "category_id"
    t.integer  "condition_id"
    t.integer  "user_id"
    t.string   "posting_image"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "state",         :default => "active"
  end

  create_table "purchases", :force => true do |t|
    t.integer  "order_id"
    t.decimal  "amount"
    t.decimal  "seller_amount"
    t.decimal  "fee_amount"
    t.string   "paypal_pay_key"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.binary   "serialized_response"
  end

  create_table "shipping_services", :force => true do |t|
    t.string   "name"
    t.integer  "sort_order"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "logo_identifier"
  end

  create_table "shipping_speeds", :force => true do |t|
    t.string   "name"
    t.integer  "sort_order"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "user_name"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "first_name"
    t.string   "last_name"
  end

end
