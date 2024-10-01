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

ActiveRecord::Schema[7.1].define(version: 2024_10_01_014854) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "matches", force: :cascade do |t|
    t.date "match_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "play_players", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "play_id", null: false
    t.integer "games_won"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "games_lost"
    t.boolean "winner"
    t.index ["play_id"], name: "index_play_players_on_play_id"
    t.index ["player_id"], name: "index_play_players_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "gender"
    t.string "name"
    t.integer "games_won"
    t.integer "games_lost"
    t.integer "sets_won"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "matches_count"
    t.integer "games_balance"
  end

  create_table "plays", force: :cascade do |t|
    t.bigint "match_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date_play"
    t.integer "dupla1", default: [], array: true
    t.integer "dupla2", default: [], array: true
    t.integer "dupla1_games"
    t.integer "dupla2_games"
    t.index ["match_id"], name: "index_plays_on_match_id"
  end

  add_foreign_key "play_players", "players"
  add_foreign_key "play_players", "plays"
  add_foreign_key "plays", "matches"
end
