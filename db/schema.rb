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

ActiveRecord::Schema.define(version: 2021_03_07_183505) do

  create_table "tasks", force: :cascade do |t|
    t.string "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "done", default: false
    t.integer "reporter_id"
    t.integer "assignee_id"
    t.index ["assignee_id"], name: "index_tasks_on_assignee_id"
    t.index ["reporter_id"], name: "index_tasks_on_reporter_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "slack_handle"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slack_id"
  end

end
