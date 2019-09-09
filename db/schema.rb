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

ActiveRecord::Schema.define(version: 2019_09_09_131035) do

  create_table "batrobs", force: :cascade do |t|
    t.integer "hitpoints"
    t.integer "robot_id"
    t.integer "battle_id"
  end

  create_table "battles", force: :cascade do |t|
    t.string "winner"
  end

  create_table "players", force: :cascade do |t|
    t.string "username"
  end

  create_table "robots", force: :cascade do |t|
    t.string "name"
    t.integer "player_id"
  end

end
