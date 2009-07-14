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

ActiveRecord::Schema.define(:version => 14) do

  create_table "campaigns", :force => true do |t|
    t.string   "name"
    t.string   "keyword"
    t.string   "url"
    t.text     "instructions"
    t.text     "description"
    t.text     "short_description"
    t.text     "template"
    t.integer  "points"
    t.integer  "runs",              :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_runs"
    t.integer  "creator_id"
    t.datetime "start_at"
  end

  add_index "campaigns", ["creator_id"], :name => "index_campaigns_on_creator_id"
  add_index "campaigns", ["keyword"], :name => "index_campaigns_on_keyword"

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "tasks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "campaign_id"
    t.integer  "points"
    t.datetime "completed_at"
    t.string   "key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "elapsed_seconds"
  end

  add_index "tasks", ["campaign_id"], :name => "index_tasks_on_campaign_id"
  add_index "tasks", ["key"], :name => "index_tasks_on_key"
  add_index "tasks", ["user_id", "campaign_id"], :name => "index_tasks_on_user_id_and_campaign_id"

  create_table "users", :force => true do |t|
    t.boolean  "admin",               :default => false
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login",                                  :null => false
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token",                      :null => false
    t.string   "openid_identifier"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "organization_name"
    t.boolean  "subscribe_campaigns", :default => false
    t.boolean  "subscribe_all",       :default => false
  end

  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["openid_identifier"], :name => "index_users_on_openid_identifier"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"
  add_index "users", ["subscribe_all"], :name => "index_users_on_subscribe_all"
  add_index "users", ["subscribe_campaigns"], :name => "index_users_on_subscribe_campaigns"

end
