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

ActiveRecord::Schema.define(version: 20170318043038) do

  create_table "commitments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "description"
    t.date     "deadline"
    t.integer  "execution"
    t.integer  "count"
    t.integer  "user"
    t.integer  "course"
    t.integer  "product_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["product_id"], name: "index_commitments_on_product_id", using: :btree
  end

  create_table "course_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.string   "rol"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "team_id"
    t.index ["team_id"], name: "index_course_users_on_team_id", using: :btree
    t.index ["user_id", "course_id"], name: "index_course_users_on_user_id_and_course_id", using: :btree
  end

  create_table "courses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name",                   limit: 80,    null: false
    t.string   "initials",               limit: 8
    t.string   "period_type",            limit: 45
    t.string   "section",                limit: 2
    t.string   "category",               limit: 45
    t.string   "institute",              limit: 100
    t.string   "content",                limit: 120
    t.string   "privacy",                limit: 15
    t.boolean  "inscriptions_activated"
    t.boolean  "evaluate_teacher"
    t.boolean  "strict_mode_isa"
    t.boolean  "code_confirmed"
    t.string   "logo",                   limit: 200
    t.integer  "period_length",          limit: 1
    t.text     "description",            limit: 65535
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "product_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_users_on_product_id", using: :btree
    t.index ["user_id"], name: "index_product_users_on_user_id", using: :btree
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name",        limit: 80
    t.string   "description"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "team_id"
    t.string   "logo",        limit: 120
    t.index ["team_id"], name: "index_products_on_team_id", using: :btree
  end

  create_table "tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "description"
    t.date     "deadline"
    t.integer  "execution"
    t.integer  "weight"
    t.integer  "commitment_id"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["commitment_id"], name: "index_tasks_on_commitment_id", using: :btree
    t.index ["user_id"], name: "index_tasks_on_user_id", using: :btree
  end

  create_table "teams", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name",        limit: 80,  null: false
    t.string   "description", limit: 120
    t.string   "initials",    limit: 8
    t.string   "logo",        limit: 200
    t.integer  "course_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["course_id"], name: "index_teams_on_course_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "names",           limit: 50,  null: false
    t.string   "lastnames",       limit: 50,  null: false
    t.string   "email",           limit: 64,  null: false
    t.string   "password_digest", limit: 65,  null: false
    t.string   "initials",        limit: 8
    t.string   "country",         limit: 32
    t.string   "city",            limit: 32
    t.string   "phone",           limit: 32
    t.string   "sn_one",          limit: 40
    t.string   "sn_two",          limit: 40
    t.string   "skills"
    t.string   "reset_digest",    limit: 65
    t.datetime "reset_sent_at"
    t.string   "image_user",      limit: 200
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_foreign_key "course_users", "teams"
  add_foreign_key "products", "teams"
end
