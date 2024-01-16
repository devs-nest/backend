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

ActiveRecord::Schema[7.0].define(version: 2024_01_16_180921) do
  create_table "algo_submissions", charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.integer "challenge_id"
    t.text "source_code"
    t.string "language"
    t.json "test_cases"
    t.integer "total_test_cases", default: 0
    t.integer "passed_test_cases", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_submitted"
    t.string "status"
    t.string "total_runtime"
    t.string "total_memory"
    t.boolean "is_best_submission", default: false
    t.integer "coding_room_id"
    t.index ["challenge_id", "coding_room_id"], name: "index_algo_submissions_on_challenge_id_and_coding_room_id"
    t.index ["is_submitted", "status"], name: "index_algo_submissions_on_is_submitted_and_status"
    t.index ["user_id", "challenge_id"], name: "index_algo_submissions_on_user_id_and_challenge_id"
  end

  create_table "algo_templates", charset: "utf8mb3", force: :cascade do |t|
    t.integer "challenge_id"
    t.integer "language_id"
    t.text "head"
    t.text "body"
    t.text "tail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["challenge_id", "language_id"], name: "index_algo_templates_on_challenge_id_and_language_id", unique: true
  end

  create_table "article_submissions", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "article_id", null: false
    t.bigint "user_id", null: false
    t.string "submission_link"
    t.index ["article_id", "user_id"], name: "index_article_submissions_on_article_id_and_user_id", unique: true
    t.index ["article_id"], name: "index_article_submissions_on_article_id"
    t.index ["user_id"], name: "index_article_submissions_on_user_id"
  end

  create_table "articles", charset: "utf8mb3", force: :cascade do |t|
    t.string "title"
    t.string "author"
    t.text "content"
    t.string "banner"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.integer "resource_type", null: false
    t.index ["resource_type"], name: "index_articles_on_resource_type"
    t.index ["slug"], name: "index_articles_on_slug", unique: true
  end

  create_table "assignment_questions", charset: "utf8mb3", force: :cascade do |t|
    t.integer "course_curriculum_id"
    t.integer "question_id"
    t.string "question_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "audits", charset: "utf8mb3", force: :cascade do |t|
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
    t.datetime "created_at", precision: nil
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "backend_challenge_scores", charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.integer "backend_challenge_id"
    t.integer "be_submission_id"
    t.integer "total_test_cases", default: 0
    t.integer "passed_test_cases", default: 0
    t.float "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "backend_challenge_id"], name: "backend_challenge_score_index", unique: true
  end

  create_table "backend_challenges", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.integer "day_no"
    t.integer "topic"
    t.integer "difficulty"
    t.string "slug"
    t.text "question_body"
    t.integer "score", default: 0
    t.boolean "is_active", default: false
    t.integer "user_id"
    t.integer "course_curriculum_id"
    t.string "testcases_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "active_path"
    t.text "files"
    t.string "folder_name"
    t.text "hidden_files"
    t.text "open_paths"
    t.text "protected_paths"
    t.string "template"
    t.integer "challenge_type", default: 0
    t.boolean "is_project", default: false
    t.index ["slug"], name: "index_backend_challenges_on_slug", unique: true
  end

  create_table "batch_leader_sheets", charset: "utf8mb3", force: :cascade do |t|
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

  create_table "batches", charset: "utf8mb3", force: :cascade do |t|
    t.integer "owner_id"
    t.string "name", default: "", null: false
    t.integer "members_count"
    t.integer "student_mentor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "be_submissions", charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.integer "backend_challenge_id"
    t.integer "total_test_cases", default: 0
    t.integer "passed_test_cases", default: 0
    t.text "failed_test_cases_desc"
    t.text "passed_test_cases_desc"
    t.float "score"
    t.text "submitted_url"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "result"
    t.index ["user_id", "backend_challenge_id"], name: "backend_submission_user_index"
  end

  create_table "bootcamp_progresses", charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.integer "course_id"
    t.integer "course_curriculum_id"
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "course_module_id"
    t.index ["user_id"], name: "index_bootcamp_progresses_on_user_id"
  end

  create_table "certifications", charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.string "certificate_type"
    t.string "cuid", default: "P78jC6_Z2cQ"
    t.string "title", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "certificate_type"], name: "index_certificates_on_user_id_and_certificate_type", unique: true
  end

  create_table "challenges", charset: "utf8mb3", force: :cascade do |t|
    t.integer "topic"
    t.integer "difficulty"
    t.string "name"
    t.text "question_body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "score", default: 0
    t.integer "priority"
    t.string "slug"
    t.boolean "is_active", default: false
    t.text "tester_code"
    t.integer "user_id"
    t.json "input_format"
    t.json "output_format"
    t.integer "content_type"
    t.string "unique_id"
    t.string "parent_id"
    t.integer "course_curriculum_id"
    t.index ["slug"], name: "index_challenges_on_slug", unique: true
  end

  create_table "coding_room_user_mappings", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "coding_room_id", null: false
    t.bigint "user_id", null: false
    t.boolean "has_left", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coding_room_id", "user_id"], name: "index_coding_room_user_mappings_on_coding_room_id_and_user_id"
    t.index ["coding_room_id"], name: "index_coding_room_user_mappings_on_coding_room_id"
    t.index ["user_id", "has_left"], name: "index_coding_room_user_mappings_on_user_id_and_has_left"
    t.index ["user_id"], name: "index_coding_room_user_mappings_on_user_id"
  end

  create_table "coding_rooms", charset: "utf8mb3", force: :cascade do |t|
    t.string "unique_id"
    t.string "name"
    t.integer "room_time"
    t.text "challenge_list"
    t.boolean "is_private", default: false
    t.datetime "finish_at", precision: nil
    t.boolean "is_active", default: true
    t.boolean "has_started", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.datetime "starts_at", precision: nil, null: false
    t.string "difficulty", null: false
    t.string "topics", null: false
    t.integer "question_count", null: false
    t.index ["finish_at"], name: "index_coding_rooms_on_finish_at"
    t.index ["is_active"], name: "index_coding_rooms_on_is_active"
    t.index ["unique_id"], name: "index_coding_rooms_on_unique_id"
  end

  create_table "coin_logs", charset: "utf8mb3", force: :cascade do |t|
    t.string "pointable_type"
    t.integer "pointable_id"
    t.integer "coins", default: 0
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "college_branches", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "college_id", null: false
    t.json "branches"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["college_id"], name: "index_college_branches_on_college_id"
  end

  create_table "college_enquiries", charset: "utf8mb3", force: :cascade do |t|
    t.string "phone_number"
    t.integer "enquiry_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["phone_number"], name: "index_college_enquiries_on_phone_number"
  end

  create_table "college_forms", charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.string "tpo_or_faculty_name", null: false
    t.string "college_name"
    t.string "faculty_position"
    t.string "email"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "college_invites", charset: "utf8mb3", force: :cascade do |t|
    t.integer "college_profile_id"
    t.integer "college_id"
    t.text "uid"
    t.integer "status", default: 0
    t.integer "authority_level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "college_profiles", charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.integer "college_id"
    t.integer "college_structure_id"
    t.integer "authority_level"
    t.integer "department"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "roll_number"
    t.index ["email"], name: "index_college_profiles_on_email", unique: true
    t.index ["roll_number"], name: "index_college_profiles_on_roll_number", unique: true
  end

  create_table "college_structures", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.integer "course"
    t.string "batch"
    t.integer "year"
    t.integer "branch"
    t.integer "specialization"
    t.string "section"
    t.integer "college_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "college_students", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.date "dob"
    t.string "email"
    t.integer "gender"
    t.string "parent_name"
    t.string "parent_phone"
    t.string "parent_email"
    t.integer "high_school_board_type"
    t.string "high_school_board"
    t.string "high_school_name"
    t.string "high_school_passing_year"
    t.integer "high_school_result"
    t.string "diploma_university_name"
    t.string "diploma_passing_year"
    t.integer "diploma_result"
    t.integer "higher_secondary_board_type"
    t.string "higher_secondary_board"
    t.string "higher_secondary_school_name"
    t.string "higher_secondary_passing_year"
    t.integer "higher_secondary_result"
    t.integer "state", default: 0
    t.integer "higher_education_type"
    t.boolean "phone_verified", default: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "coding_exp"
    t.text "coding_summary"
  end

  create_table "colleges", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.boolean "is_verified", default: false
    t.string "slug"
    t.index ["slug"], name: "index_colleges_on_slug", unique: true
  end

  create_table "companies", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_url"
    t.index ["name"], name: "index_companies_on_name", unique: true
  end

  create_table "company_challenge_mappings", charset: "utf8mb3", force: :cascade do |t|
    t.integer "challenge_id"
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["challenge_id", "company_id"], name: "index_company_challenge_mappings_on_challenge_id_and_company_id", unique: true
  end

  create_table "contents", charset: "utf8mb3", force: :cascade do |t|
    t.string "unique_id"
    t.string "parent_id"
    t.string "name"
    t.integer "data_type"
    t.string "link"
    t.integer "priority"
    t.string "extra_link1"
    t.string "extra_link2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "score"
    t.integer "difficulty"
    t.integer "question_type"
    t.json "video_questions"
    t.json "reference_data"
    t.index ["parent_id"], name: "index_contents_on_parent_id"
    t.index ["unique_id"], name: "index_contents_on_unique_id"
  end

  create_table "course_curriculums", charset: "utf8mb3", force: :cascade do |t|
    t.integer "course_id"
    t.integer "course_type"
    t.string "topic"
    t.integer "day"
    t.text "video_link"
    t.json "resources"
    t.boolean "locked", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "extra_data"
    t.integer "course_module_id"
    t.index ["course_id", "course_type"], name: "index_course_curriculums_on_course_id_and_course_type"
    t.index ["course_id", "day"], name: "index_course_curriculums_on_course_id_and_day"
  end

  create_table "course_module_accesses", charset: "utf8mb3", force: :cascade do |t|
    t.string "accessor_type", null: false
    t.bigint "accessor_id", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "course_module_id", null: false
    t.index ["accessor_type", "accessor_id"], name: "index_course_module_accesses_on_accessor"
    t.index ["course_module_id"], name: "index_course_module_accesses_on_course_module_id"
  end

  create_table "course_module_mappings", charset: "utf8mb3", force: :cascade do |t|
    t.integer "course_module_id"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id", "course_module_id"], name: "course_module_mapping_index"
  end

  create_table "course_modules", charset: "utf8mb3", force: :cascade do |t|
    t.integer "module_type"
    t.integer "questions_table"
    t.integer "best_submissions_table"
    t.integer "submissions_table"
    t.boolean "is_paid", default: false
    t.integer "timeline_status", default: 0
    t.integer "visibility", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "courses", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.boolean "archived", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "current_module"
    t.index ["name"], name: "index_courses_on_name"
  end

  create_table "discussions", charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.integer "question_id"
    t.integer "parent_id"
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.string "question_type"
    t.index ["question_id", "parent_id"], name: "index_discussions_on_question_id_and_parent_id"
    t.index ["slug"], name: "index_discussions_on_slug", unique: true
    t.index ["user_id"], name: "index_discussions_on_user_id"
  end

  create_table "edu_events", charset: "utf8mb3", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.date "starting_date"
    t.date "ending_date"
    t.string "organizer"
    t.json "form_columns"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "email_templates", charset: "utf8mb3", force: :cascade do |t|
    t.string "template_id"
    t.string "name"
    t.index ["template_id", "name"], name: "index_email_templates_on_template_id_and_name"
  end

  create_table "event_registrations", charset: "utf8mb3", force: :cascade do |t|
    t.integer "edu_event_id"
    t.integer "user_id"
    t.json "user_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["edu_event_id"], name: "index_event_registrations_on_edu_event_id"
    t.index ["user_id", "edu_event_id"], name: "index_event_registrations_on_user_id_and_edu_event_id", unique: true
  end

  create_table "events", charset: "utf8mb3", force: :cascade do |t|
    t.string "event_type"
    t.text "message"
    t.integer "bot_type"
    t.string "bot_details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fe_submissions", charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.integer "frontend_challenge_id"
    t.integer "total_test_cases", default: 0
    t.integer "passed_test_cases", default: 0
    t.integer "score"
    t.text "result"
    t.string "question_type"
    t.boolean "is_submitted", default: false
    t.text "source_code"
    t.string "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id", "frontend_challenge_id"], name: "frontend_submission_user_index"
  end

  create_table "frontend_challenge_scores", charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.integer "frontend_challenge_id"
    t.integer "fe_submission_id"
    t.integer "total_test_cases", default: 0
    t.integer "passed_test_cases", default: 0
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "frontend_challenge_id"], name: "frontend_challenge_score_index", unique: true
  end

  create_table "frontend_challenges", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.integer "day_no"
    t.string "folder_name"
    t.integer "topic"
    t.integer "difficulty"
    t.string "slug"
    t.text "question_body"
    t.integer "score", default: 0
    t.boolean "is_active", default: false
    t.integer "user_id"
    t.integer "course_curriculum_id"
    t.string "testcases_path"
    t.text "hidden_files"
    t.text "protected_paths"
    t.text "open_paths"
    t.string "template"
    t.string "active_path"
    t.string "challenge_type"
    t.text "files"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_project", default: false
    t.index ["slug"], name: "index_frontend_challenges_on_slug", unique: true
  end

  create_table "frontend_projects", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.integer "template"
    t.boolean "public", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["user_id", "name"], name: "index_projects_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_frontend_projects_on_user_id"
  end

  create_table "frontend_questions", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.text "question_markdown"
    t.integer "template"
    t.string "active_path"
    t.text "open_paths"
    t.text "protected_paths"
    t.boolean "show_explorer"
    t.text "hidden_files"
  end

  create_table "frontend_submissions", charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.integer "content_id"
    t.string "submission_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_members", charset: "utf8mb3", force: :cascade do |t|
    t.boolean "scrum_master"
    t.boolean "owner"
    t.boolean "student_mentor"
    t.integer "user_id"
    t.integer "group_id"
    t.integer "batch_id"
    t.integer "members_count"
    t.integer "student_mentor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "group_id"], name: "index_group_members_on_user_id_and_group_id", unique: true
    t.index ["user_id"], name: "index_group_members_on_user_id"
  end

  create_table "groups", charset: "utf8mb3", force: :cascade do |t|
    t.integer "owner_id"
    t.integer "batch_id"
    t.string "name", default: "", null: false
    t.integer "members_count", default: 0
    t.integer "student_mentor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "co_owner_id"
    t.integer "batch_leader_id"
    t.string "slug"
    t.integer "version", default: 2
    t.integer "group_type", default: 0
    t.integer "language", default: 0
    t.integer "classification", default: 0
    t.text "description"
    t.integer "server_id", default: 1
    t.boolean "five_members_flag", default: false
    t.time "scrum_start_time", default: "2000-01-01 14:30:00"
    t.time "scrum_end_time", default: "2000-01-01 15:00:00"
    t.integer "activity_point", default: 0
    t.integer "bootcamp_type", default: 0
    t.index ["members_count"], name: "index_groups_on_members_count"
    t.index ["name"], name: "index_groups_on_name", unique: true
    t.index ["slug"], name: "index_groups_on_slug", unique: true
  end

  create_table "hackathons", charset: "utf8mb3", force: :cascade do |t|
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

  create_table "internal_feedbacks", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id"
    t.boolean "is_resolved", default: false
    t.string "problems_faced", default: ""
    t.text "issue_details"
    t.text "solution"
    t.integer "issue_scale", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_name"
    t.string "feedback_type"
    t.integer "group_activity_rating"
    t.integer "TL_rating"
    t.string "VTL_rating"
    t.text "group_morale"
    t.text "obstacles_faced"
    t.string "BL_availability"
    t.integer "BL_rating"
    t.text "comments_on_BL"
    t.text "tl_vtl_feedback"
    t.integer "most_helpful_teammate_id"
    t.index ["user_id"], name: "index_internal_feedbacks_on_user_id"
  end

  create_table "job_applications", charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.integer "job_id"
    t.integer "status"
    t.string "email"
    t.string "phone_number"
    t.string "note_for_the_recruiter"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "job_id"], name: "index_job_applications_on_user_id_and_job_id", unique: true
  end

  create_table "job_skill_mappings", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "skill_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id", "skill_id"], name: "index_job_skill_mappings_on_job_id_and_skill_id", unique: true
    t.index ["job_id"], name: "index_job_skill_mappings_on_job_id"
    t.index ["skill_id"], name: "index_job_skill_mappings_on_skill_id"
  end

  create_table "jobs", charset: "utf8mb3", force: :cascade do |t|
    t.integer "organization_id"
    t.integer "user_id"
    t.string "title"
    t.text "description"
    t.string "salary"
    t.integer "job_type"
    t.integer "job_category"
    t.string "location"
    t.string "experience"
    t.boolean "archived", default: false
    t.json "additional"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_jobs_on_slug", unique: true
  end

  create_table "judgeztokens", charset: "utf8mb3", force: :cascade do |t|
    t.integer "submission_id"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token", "submission_id"], name: "index_judgeztokens_on_token_and_submission_id"
  end

  create_table "jwt_blacklists", charset: "utf8mb3", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", precision: nil
    t.index ["jti"], name: "index_jwt_blacklists_on_jti"
  end

  create_table "language_challenge_mappings", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "challenge_id", null: false
    t.bigint "language_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["challenge_id"], name: "index_language_challenge_mappings_on_challenge_id"
    t.index ["language_id"], name: "index_language_challenge_mappings_on_language_id"
  end

  create_table "languages", charset: "utf8mb3", force: :cascade do |t|
    t.integer "judge_zero_id"
    t.string "name"
    t.string "memory_limit"
    t.string "time_limit"
    t.string "type_array", default: ""
    t.string "type_matrix", default: ""
    t.string "type_string", default: ""
    t.string "type_primitive", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "language_description"
    t.string "type_linked_list"
    t.string "type_binary_tree"
  end

  create_table "links", charset: "utf8mb3", force: :cascade do |t|
    t.string "slug"
    t.text "address"
    t.index ["slug"], name: "index_links_on_slug", unique: true
  end

  create_table "manual_login_changelogs", charset: "utf8mb3", force: :cascade do |t|
    t.integer "query_type"
    t.text "uid"
    t.boolean "is_fulfilled", default: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_manual_login_changelogs_on_user_id"
  end

  create_table "markdowns", charset: "utf8mb3", force: :cascade do |t|
    t.text "template"
  end

  create_table "minibootcamp_submissions", charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.integer "frontend_question_id"
    t.boolean "is_solved"
    t.string "submission_link"
    t.string "submission_status"
    t.index ["user_id", "frontend_question_id"], name: "index_on_user_and_frontend_question", unique: true
  end

  create_table "minibootcamps", charset: "utf8mb3", force: :cascade do |t|
    t.integer "frontend_question_id"
    t.string "unique_id", null: false
    t.string "parent_id"
    t.string "name"
    t.integer "content_type"
    t.text "markdown"
    t.string "video_link"
    t.string "image_url"
    t.integer "current_lesson_number"
    t.boolean "show_ide"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["frontend_question_id"], name: "index_minibootcamps_on_frontend_question_id"
  end

  create_table "notification_bots", charset: "utf8mb3", force: :cascade do |t|
    t.string "bot_token"
    t.string "bot_username"
    t.boolean "is_generic_bot", default: false
    t.boolean "is_used", default: false
  end

  create_table "notifications", charset: "utf8mb3", force: :cascade do |t|
    t.text "message"
    t.json "users"
    t.boolean "is_sent", default: false
    t.date "date_to_be_sent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", charset: "utf8mb3", force: :cascade do |t|
    t.string "razorpay_order_id"
    t.string "razorpay_payment_id"
    t.string "razorpay_signature"
    t.string "razorpay_payment_link_id"
    t.string "payment_link"
    t.float "amount"
    t.string "description"
    t.string "status"
    t.integer "user_id"
    t.string "currency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "product_price_id"
  end

  create_table "organizations", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.text "description"
    t.string "website"
    t.string "logo_banner"
    t.string "logo"
    t.string "heading"
    t.json "additional"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_organizations_on_slug", unique: true
  end

  create_table "otp_logs", charset: "utf8mb3", force: :cascade do |t|
    t.string "phone_number"
    t.integer "timeout"
    t.integer "request_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["phone_number"], name: "index_otp_logs_on_phone_number"
  end

  create_table "product_discounts", charset: "utf8mb3", force: :cascade do |t|
    t.integer "product_id"
    t.decimal "discount", precision: 10, scale: 2
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_prices", charset: "utf8mb3", force: :cascade do |t|
    t.integer "price"
    t.string "product_type", null: false
    t.string "product_name"
    t.text "product_id"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "redirect_url", default: ""
  end

  create_table "projects", charset: "utf8mb3", force: :cascade do |t|
    t.integer "challenge_id"
    t.string "challenge_type"
    t.string "banner"
    t.text "intro"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "referrals", charset: "utf8mb3", force: :cascade do |t|
    t.integer "referred_user_id"
    t.string "referral_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "referred_by"
    t.integer "referral_type", default: 0
  end

  create_table "rewards", charset: "utf8mb3", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "room_best_submissions", charset: "utf8mb3", force: :cascade do |t|
    t.integer "challenge_id"
    t.integer "user_id"
    t.integer "coding_room_id"
    t.integer "algo_submission_id"
    t.integer "total_test_cases"
    t.integer "passed_test_cases"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "challenge_id", "coding_room_id"], name: "index_room_best_submission", unique: true
  end

  create_table "run_submissions", charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.integer "challenge_id"
    t.text "source_code"
    t.string "language"
    t.json "test_cases"
    t.integer "total_test_cases", default: 0
    t.integer "passed_test_cases", default: 0
    t.string "total_runtime"
    t.string "total_memory"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "challenge_id"], name: "index_run_submissions_on_user_id_and_challenge_id"
  end

  create_table "scrums", charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.boolean "attendance"
    t.boolean "saw_last_lecture"
    t.string "tha_progress"
    t.string "topics_to_cover"
    t.text "backlog_reasons"
    t.integer "class_rating"
    t.date "creation_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "last_tha_link"
    t.json "total_assignments_solved"
    t.json "recent_assignments_solved"
    t.index ["user_id", "creation_date"], name: "index_scrums_on_user_id_and_creation_date", unique: true
  end

  create_table "server_users", charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.integer "server_id"
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "server_id"], name: "index_server_users_on_user_id_and_server_id"
  end

  create_table "servers", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "guild_id"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "skills", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "logo", size: :medium
  end

  create_table "sql_challenges", charset: "utf8mb3", force: :cascade do |t|
    t.string "title"
    t.integer "score"
    t.integer "difficulty"
    t.boolean "is_active"
    t.string "created_by"
    t.integer "user_id"
    t.string "slug"
    t.string "topic"
    t.text "question_body"
    t.boolean "status"
    t.string "expected_output"
    t.string "initial_sql_file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "sql_challenge_user_index"
  end

  create_table "sql_submissions", charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.integer "sql_challenge_id"
    t.integer "score"
    t.boolean "passed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "sql_challenge_id"], name: "sql_submission_user_challenge_index"
  end

  create_table "submissions", charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.integer "content_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "content_id"], name: "index_submissions_on_user_id_and_content_id", unique: true
  end

  create_table "testcases", charset: "utf8mb3", force: :cascade do |t|
    t.integer "challenge_id"
    t.boolean "is_sample"
    t.string "input_path"
    t.string "output_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["challenge_id", "is_sample"], name: "index_testcases_on_challenge_id_and_is_sample"
  end

  create_table "unsubscribes", charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.integer "category", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "category"], name: "index_unsubscribes_on_user_id_and_category", unique: true
  end

  create_table "upvotes", charset: "utf8mb3", force: :cascade do |t|
    t.integer "content_id"
    t.string "content_type"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "content_id", "content_type"], name: "index_upvotes_on_user_id_and_content_id_and_content_type", unique: true
  end

  create_table "user_challenge_scores", charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.integer "challenge_id"
    t.integer "algo_submission_id"
    t.integer "total_test_cases"
    t.integer "passed_test_cases"
    t.integer "score", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "challenge_id"], name: "index_user_challenge_scores_on_user_id_and_challenge_id", unique: true
  end

  create_table "user_integration_caches", charset: "utf8mb3", force: :cascade do |t|
    t.text "leetcode_cache", size: :medium
    t.text "gfg_cache", size: :medium
    t.text "hackerrank_cache", size: :medium
    t.text "github_cache", size: :medium
    t.integer "user_integration_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_integrations", charset: "utf8mb3", force: :cascade do |t|
    t.string "leetcode_user_name"
    t.string "gfg_user_name"
    t.string "hackerrank_user_name"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_skills", charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.integer "skill_id"
    t.integer "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", default: ""
    t.string "bio", default: ""
    t.string "image_url", default: ""
    t.integer "kind", default: 0
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username", default: "", null: false
    t.integer "buddy", default: 0
    t.string "discord_id", default: "", null: false
    t.integer "role"
    t.float "score", default: 0.0
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
    t.boolean "group_assigned", default: false
    t.integer "bot_id"
    t.boolean "is_verified", default: false
    t.string "working_status"
    t.boolean "is_fullstack_course_22_form_filled", default: false
    t.string "phone_number"
    t.string "working_role"
    t.string "company_name"
    t.string "college_name"
    t.integer "college_year"
    t.boolean "is_college_form_filled", default: false
    t.boolean "accepted_in_course", default: false
    t.string "enrolled_for_course_image_url"
    t.boolean "previously_joined_a_group", default: false
    t.string "referral_code"
    t.integer "coins", default: 0
    t.text "github_token"
    t.integer "fe_score", default: 0
    t.integer "listmonk_subscriber_id"
    t.integer "be_score", default: 0
    t.text "github_repos"
    t.integer "dsa_streak", default: 0
    t.date "streak_end_date"
    t.integer "last_dsa_streak", default: 0
    t.boolean "is_college_student", default: false
    t.boolean "dn_airtribe_student", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "versions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "item_type", limit: 191, null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", size: :long
    t.datetime "created_at", precision: nil
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "weekly_todos", charset: "utf8mb3", force: :cascade do |t|
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

  add_foreign_key "article_submissions", "articles"
  add_foreign_key "article_submissions", "users"
  add_foreign_key "coding_room_user_mappings", "coding_rooms"
  add_foreign_key "coding_room_user_mappings", "users"
  add_foreign_key "college_branches", "colleges"
  add_foreign_key "course_module_accesses", "course_modules"
  add_foreign_key "job_skill_mappings", "jobs"
  add_foreign_key "job_skill_mappings", "skills"
  add_foreign_key "language_challenge_mappings", "challenges"
  add_foreign_key "language_challenge_mappings", "languages"
end
