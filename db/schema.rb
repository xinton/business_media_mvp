# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_07_25_234013) do
  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stories", force: :cascade do |t|
    t.string "headline"
    t.text "body"
    t.string "status"
    t.integer "chief_id", null: false
    t.integer "writer_id"
    t.integer "reviewer_id"
    t.integer "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chief_id"], name: "index_stories_on_chief_id"
    t.index ["organization_id"], name: "index_stories_on_organization_id"
    t.index ["reviewer_id"], name: "index_stories_on_reviewer_id"
    t.index ["writer_id"], name: "index_stories_on_writer_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "role"
    t.integer "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_users_on_organization_id"
  end

  add_foreign_key "stories", "organizations"
  add_foreign_key "stories", "users", column: "chief_id"
  add_foreign_key "stories", "users", column: "reviewer_id"
  add_foreign_key "stories", "users", column: "writer_id"
  add_foreign_key "users", "organizations"
end
