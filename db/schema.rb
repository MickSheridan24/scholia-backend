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

ActiveRecord::Schema.define(version: 2020_10_15_020052) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "annotation_categories", force: :cascade do |t|
    t.integer "annotation_id"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "annotations", force: :cascade do |t|
    t.integer "book_id"
    t.integer "user_id"
    t.integer "study_id"
    t.string "title"
    t.integer "location_char_index"
    t.string "color"
    t.boolean "public"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "location_p_index"
    t.string "body"
  end

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.string "author"
    t.integer "gutenberg_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "temporary_text"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contributors", force: :cascade do |t|
    t.integer "user_id"
    t.integer "study_id"
    t.boolean "admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "annotation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sections", force: :cascade do |t|
    t.text "html"
    t.text "plain"
    t.integer "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "section_type"
    t.integer "section_number"
    t.index ["section_number"], name: "index_sections_on_section_number"
  end

  create_table "studies", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.boolean "public_subscribe"
    t.boolean "public_contribute"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
  end

  create_table "subscribers", force: :cascade do |t|
    t.integer "user_id"
    t.integer "study_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
