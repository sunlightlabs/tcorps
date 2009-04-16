# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 4) do

  create_table "campaigns", :force => true do |t|
    t.string   "name"
    t.string   "keyword"
    t.text     "instructions"
    t.text     "description"
    t.text     "private_description"
    t.text     "template"
    t.integer  "points"
    t.integer  "organization_id"
    t.integer  "runs",                :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "campaigns", ["keyword"], :name => "index_campaigns_on_keyword"
  add_index "campaigns", ["organization_id"], :name => "index_campaigns_on_organization_id"

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.string   "domain"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "campaign_id"
    t.integer  "points"
    t.datetime "completed_at"
    t.string   "key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["campaign_id"], :name => "index_tasks_on_campaign_id"
  add_index "tasks", ["key"], :name => "index_tasks_on_key"
  add_index "tasks", ["user_id", "campaign_id"], :name => "index_tasks_on_user_id_and_campaign_id"

  create_table "users", :force => true do |t|
    t.integer  "organization_id"
    t.boolean  "admin",             :default => false
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login",                                :null => false
    t.string   "crypted_password",                     :null => false
    t.string   "password_salt",                        :null => false
    t.string   "persistence_token",                    :null => false
  end

  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["organization_id"], :name => "index_users_on_organization_id"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"

end
