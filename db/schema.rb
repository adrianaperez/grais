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

ActiveRecord::Schema.define(version: 20170221230343) do

  create_table "commitment_user_relationships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "user_id"
    t.integer  "commitment_id"
    t.string   "exonerated"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["commitment_id"], name: "index_commitment_user_relationships_on_commitment_id", using: :btree
    t.index ["user_id"], name: "index_commitment_user_relationships_on_user_id", using: :btree
  end

  create_table "commitments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "description"
    t.date     "deadline"
    t.integer  "execution"
    t.integer  "count"
    t.integer  "user"
    t.integer  "course"
    t.integer  "company_id"
    t.integer  "product_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["company_id"], name: "index_commitments_on_company_id", using: :btree
    t.index ["product_id"], name: "index_commitments_on_product_id", using: :btree
  end

  create_table "companies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.integer  "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_companies_on_product_id", using: :btree
  end

  create_table "course_user_relationships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.integer  "company_id"
    t.string   "user_category"
    t.string   "user_occupation"
    t.string   "section"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["company_id"], name: "index_course_user_relationships_on_company_id", using: :btree
    t.index ["course_id"], name: "index_course_user_relationships_on_course_id", using: :btree
    t.index ["user_id"], name: "index_course_user_relationships_on_user_id", using: :btree
  end

  create_table "courses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name",         limit: 32,    null: false
    t.text     "description",  limit: 65535
    t.string   "registration"
    t.string   "strict_isa"
    t.string   "evaluation"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
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
