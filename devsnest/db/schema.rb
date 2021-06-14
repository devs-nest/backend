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

ActiveRecord::Schema.define(version: 2021_06_15_051811) do

  create_table "batches", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "owner_id"
    t.string "name", default: "", null: false
    t.integer "members_count"
    t.integer "student_mentor_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "colleges", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "name"
  end

  create_table "contents", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "unique_id"
    t.string "parent_id"
    t.string "name"
    t.integer "data_type"
    t.string "link"
    t.integer "priority"
    t.string "extra_link1"
    t.string "extra_link2"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "score"
    t.integer "difficulty"
    t.integer "question_type"
    t.index ["parent_id"], name: "index_contents_on_parent_id"
    t.index ["unique_id"], name: "index_contents_on_unique_id"
  end

  create_table "group_members", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.boolean "scrum_master"
    t.boolean "owner"
    t.boolean "student_mentor"
    t.integer "user_id"
    t.integer "group_id"
    t.integer "batch_id"
    t.integer "members_count"
    t.integer "student_mentor_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "owner_id"
    t.integer "batch_id"
    t.string "name", default: "", null: false
    t.integer "members_count"
    t.integer "student_mentor_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "co_owner_id"
    t.integer "batch_leader_id"
    t.string "slug"
  end

  create_table "jwt_blacklists", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp"
    t.index ["jti"], name: "index_jwt_blacklists_on_jti"
  end

  create_table "submissions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.integer "content_id"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "content_id"], name: "index_submissions_on_user_id_and_content_id", unique: true
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", default: ""
    t.string "bio", default: ""
    t.string "image_url", default: ""
    t.integer "kind", default: 0
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username", default: "", null: false
    t.integer "buddy", default: 0
    t.string "discord_id", default: "", null: false
    t.integer "role"
    t.integer "score"
    t.string "provider"
    t.boolean "discord_active", default: false
    t.boolean "web_active", default: false
    t.string "batch"
    t.string "grad_status"
    t.string "grad_specialization"
    t.integer "grad_year"
    t.string "github_url"
    t.string "linkedin_url"
    t.string "resume_url"
    t.date "dob"
    t.integer "college_id"
    t.string "registration_num"
    t.integer "grad_start"
    t.integer "grad_end"
    t.integer "user_type", default: 0
    t.string "google_id"
    t.string "bot_token"
    t.string "google_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
