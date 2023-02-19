# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_02_19_161150) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "datasets", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.string "name"
    t.integer "slug"
    t.string "path"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_datasets_on_category_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "solution"
    t.text "guesses", default: [], array: true
    t.boolean "won"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "country"
    t.integer "time_taken"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "timezone"
    t.float "score", default: 0.0
    t.boolean "latest", default: true
  end

  create_table "meanings", force: :cascade do |t|
    t.string "keyword", null: false
    t.string "meaning", null: false
    t.string "proverb", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "missing_words", force: :cascade do |t|
    t.string "value"
    t.integer "count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "datasets", "categories"
end
