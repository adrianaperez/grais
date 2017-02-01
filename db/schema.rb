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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170130124313) do

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name",            limit: 32, null: false
    t.string   "lastname",        limit: 32, null: false
    t.string   "email",           limit: 64, null: false
    t.string   "password_digest", limit: 64, null: false
    t.date     "birth_date"
    t.string   "sex",             limit: 32
    t.string   "phone",           limit: 32
    t.string   "country",         limit: 32
    t.string   "state",           limit: 32
    t.string   "twitter_account", limit: 32
    t.string   "skills"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
  end

end
