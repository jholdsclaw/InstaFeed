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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151111212429) do

  create_table "hashtags", force: :cascade do |t|
    t.string   "hashtag"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "min_tag_id", limit: 8
    t.string   "max_tag_id", limit: 8
  end

  create_table "jh_media", force: :cascade do |t|
    t.string   "url_fullsize"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "media", force: :cascade do |t|
    t.string   "url_thumbnail"
    t.string   "url_fullsize"
    t.string   "caption"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "media_id",      limit: 8
  end

  create_table "tags", force: :cascade do |t|
    t.string   "hashtag_id"
    t.string   "medium_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tags", ["hashtag_id"], name: "index_tags_on_hashtag_id"
  add_index "tags", ["medium_id"], name: "index_tags_on_medium_id"

end
