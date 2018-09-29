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

ActiveRecord::Schema.define(version: 20180929033837) do

  create_table "friendships", force: :cascade do |t|
    t.integer "user_id"
    t.integer "friend_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend_id"], name: "index_friendships_on_friend_id"
    t.index ["user_id", "friend_id"], name: "index_friendships_on_user_id_and_friend_id"
    t.index ["user_id"], name: "index_friendships_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "requestor_id"
    t.integer "target_id"
    t.boolean "blocked", default: false
    t.index ["blocked"], name: "index_subscriptions_on_blocked"
    t.index ["requestor_id", "target_id"], name: "index_subscriptions_on_requestor_id_and_target_id"
    t.index ["requestor_id"], name: "index_subscriptions_on_requestor_id"
    t.index ["target_id"], name: "index_subscriptions_on_target_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
  end

end
