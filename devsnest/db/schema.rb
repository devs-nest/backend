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

ActiveRecord::Schema.define(version: 2021_09_14_160610) do

  create_table "audits", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "batch_leader_sheets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.integer "Coordination"
    t.integer "scrum_filled"
    t.integer "owner_active"
    t.integer "co_owner_active"
    t.integer "rating"
    t.date "creation_week"
    t.text "active_members"
    t.text "par_active_members"
    t.text "inactive_members"
    t.text "doubt_session_taker"
    t.boolean "video_scrum"
    t.text "remarks"
    t.string "tl_tha"
    t.string "vtl_tha"
    t.index ["group_id", "creation_week"], name: "index_batch_leader_sheets_on_group_id_and_creation_week", unique: true
  end

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
    t.json "video_questions"
    t.json "reference_data"
    t.index ["parent_id"], name: "index_contents_on_parent_id"
    t.index ["unique_id"], name: "index_contents_on_unique_id"
  end

  create_table "events", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "name"
    t.text "message"
    t.string "bot_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "frontend_submissions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.integer "content_id"
    t.string "submission_link"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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

  create_table "hackathons", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "title"
    t.string "tagline"
    t.string "reference"
    t.text "description"
    t.text "image"
    t.json "leaderboard"
    t.text "participation"
    t.text "judgement"
    t.text "milestones"
    t.text "prizes"
    t.integer "teams_participated"
    t.date "starting_date"
    t.date "ending_date"
    t.json "participants"
  end

  create_table "internal_feedbacks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "user_id"
    t.boolean "is_resolved", default: false
    t.string "issue_type", default: ""
    t.text "issue_described"
    t.text "feedback"
    t.integer "issue_scale", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "user_name"
    t.index ["user_id"], name: "index_internal_feedbacks_on_user_id"
  end

  create_table "jwt_blacklists", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp"
    t.index ["jti"], name: "index_jwt_blacklists_on_jti"
  end

  create_table "links", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "slug"
    t.text "address"
    t.index ["slug"], name: "index_links_on_slug", unique: true
  end

  create_table "markdowns", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.text "template"
  end

  create_table "notification_bots", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "bot_token"
    t.string "bot_username"
    t.boolean "is_generic_bot", default: false
  end

  create_table "notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.text "message"
    t.json "users"
    t.boolean "is_sent", default: false
    t.date "date_to_be_sent"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "scrums", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.boolean "attendance"
    t.boolean "saw_last_lecture"
    t.string "tha_progress"
    t.string "topics_to_cover"
    t.string "backlog_reasons"
    t.integer "class_rating"
    t.date "creation_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "last_tha_link"
    t.index ["user_id", "creation_date"], name: "index_scrums_on_user_id_and_creation_date", unique: true
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
    t.integer "update_count", default: 0
    t.integer "login_count", default: 0
    t.string "bot_token"
    t.string "google_id"
    t.string "discord_username"
    t.string "school"
    t.string "work_exp"
    t.string "known_from"
    t.integer "dsa_skill", default: 0
    t.integer "webd_skill", default: 0
    t.boolean "is_discord_form_filled", default: false
    t.text "markdown"
    t.integer "bot_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "weekly_todos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "group_id"
    t.boolean "sheet_filled"
    t.date "creation_week"
    t.integer "batch_leader_rating"
    t.integer "group_activity_rating"
    t.text "extra_activity"
    t.text "comments"
    t.integer "moral_status"
    t.text "obstacles"
    t.json "todo_list"
    t.index ["group_id", "creation_week"], name: "index_weekly_todos_on_group_id_and_creation_week", unique: true
  end

end
