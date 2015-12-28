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

ActiveRecord::Schema.define(version: 20151228014001) do

  create_table "badrecords", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "troublemaker"
    t.integer  "classroom_id"
    t.datetime "troubletime"
    t.integer  "subject_id"
    t.text     "description"
    t.boolean  "finish"
    t.datetime "deleted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "finish_man"
    t.datetime "finish_time"
  end

  add_index "badrecords", ["classroom_id"], name: "index_badrecords_on_classroom_id"
  add_index "badrecords", ["deleted_at"], name: "index_badrecords_on_deleted_at"
  add_index "badrecords", ["subject_id"], name: "index_badrecords_on_subject_id"
  add_index "badrecords", ["user_id"], name: "index_badrecords_on_user_id"

  create_table "cadres", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "position"
    t.integer  "member_id"
    t.datetime "deleted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "classroom_id"
    t.integer  "team_id"
  end

  add_index "cadres", ["classroom_id"], name: "index_cadres_on_classroom_id"
  add_index "cadres", ["member_id"], name: "index_cadres_on_member_id"
  add_index "cadres", ["team_id"], name: "index_cadres_on_team_id"
  add_index "cadres", ["user_id"], name: "index_cadres_on_user_id"

  create_table "cardboxes", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "share",      default: false
    t.integer  "lesson_id"
  end

  add_index "cardboxes", ["deleted_at"], name: "index_cardboxes_on_deleted_at"
  add_index "cardboxes", ["lesson_id"], name: "index_cardboxes_on_lesson_id"
  add_index "cardboxes", ["user_id"], name: "index_cardboxes_on_user_id"

  create_table "cards", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "practice_id"
    t.integer  "cardbox_id"
    t.decimal  "serial"
    t.integer  "degree",      default: 0
    t.datetime "nexttime"
    t.integer  "foul",        default: 0
    t.integer  "count",       default: 0
    t.datetime "deleted_at"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "sequence"
  end

  add_index "cards", ["cardbox_id"], name: "index_cards_on_cardbox_id"
  add_index "cards", ["deleted_at"], name: "index_cards_on_deleted_at"
  add_index "cards", ["practice_id"], name: "index_cards_on_practice_id"
  add_index "cards", ["user_id"], name: "index_cards_on_user_id"

  create_table "cashiers", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "cashiers", ["deleted_at"], name: "index_cashiers_on_deleted_at"
  add_index "cashiers", ["user_id"], name: "index_cashiers_on_user_id"

  create_table "catalogs", force: :cascade do |t|
    t.decimal  "serial"
    t.integer  "user_id"
    t.integer  "textbook_id"
    t.integer  "lesson_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "deleted_at"
  end

  add_index "catalogs", ["deleted_at"], name: "index_catalogs_on_deleted_at"
  add_index "catalogs", ["lesson_id"], name: "index_catalogs_on_lesson_id"
  add_index "catalogs", ["textbook_id"], name: "index_catalogs_on_textbook_id"
  add_index "catalogs", ["user_id"], name: "index_catalogs_on_user_id"

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type"

  create_table "classgroupscores", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.decimal  "score"
    t.string   "domain"
    t.string   "memo"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "classgroupscores", ["deleted_at"], name: "index_classgroupscores_on_deleted_at"
  add_index "classgroupscores", ["team_id"], name: "index_classgroupscores_on_team_id"
  add_index "classgroupscores", ["user_id"], name: "index_classgroupscores_on_user_id"

  create_table "classpersonscores", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "member_id"
    t.decimal  "score"
    t.integer  "classgroupscore_id"
    t.datetime "deleted_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "classpersonscores", ["classgroupscore_id"], name: "index_classpersonscores_on_classgroupscore_id"
  add_index "classpersonscores", ["deleted_at"], name: "index_classpersonscores_on_deleted_at"
  add_index "classpersonscores", ["member_id"], name: "index_classpersonscores_on_member_id"
  add_index "classpersonscores", ["user_id"], name: "index_classpersonscores_on_user_id"

  create_table "classrooms", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.boolean  "end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  add_index "classrooms", ["deleted_at"], name: "index_classrooms_on_deleted_at"
  add_index "classrooms", ["user_id"], name: "index_classrooms_on_user_id"

  create_table "complaints", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "url"
    t.text     "content"
    t.datetime "deleted_at"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
  end

  add_index "complaints", ["deleted_at"], name: "index_complaints_on_deleted_at"
  add_index "complaints", ["user_id"], name: "index_complaints_on_user_id"

  create_table "discussions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "classroom_id"
    t.integer  "lesson_id"
    t.integer  "teaching_id"
    t.boolean  "end"
    t.datetime "deleted_at"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "textbook_id"
    t.datetime "end_at"
    t.boolean  "is_ready",     default: false
  end

  add_index "discussions", ["classroom_id"], name: "index_discussions_on_classroom_id"
  add_index "discussions", ["deleted_at"], name: "index_discussions_on_deleted_at"
  add_index "discussions", ["lesson_id"], name: "index_discussions_on_lesson_id"
  add_index "discussions", ["teaching_id"], name: "index_discussions_on_teaching_id"
  add_index "discussions", ["textbook_id"], name: "index_discussions_on_textbook_id"
  add_index "discussions", ["user_id"], name: "index_discussions_on_user_id"

  create_table "evaluations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "practice_id"
    t.string   "title"
    t.text     "question"
    t.text     "answer"
    t.text     "your_answer"
    t.decimal  "score"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.decimal  "practice_score"
    t.string   "picture_ya_file_name"
    t.string   "picture_ya_content_type"
    t.integer  "picture_ya_file_size"
    t.datetime "picture_ya_updated_at"
    t.datetime "deleted_at"
    t.integer  "lesson_id"
    t.text     "material"
  end

  add_index "evaluations", ["deleted_at"], name: "index_evaluations_on_deleted_at"
  add_index "evaluations", ["lesson_id"], name: "index_evaluations_on_lesson_id"
  add_index "evaluations", ["practice_id"], name: "index_evaluations_on_practice_id"
  add_index "evaluations", ["user_id"], name: "index_evaluations_on_user_id"

  create_table "exercises", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "tutor_id"
    t.decimal  "serial"
    t.integer  "practice_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "deleted_at"
  end

  add_index "exercises", ["deleted_at"], name: "index_exercises_on_deleted_at"
  add_index "exercises", ["practice_id"], name: "index_exercises_on_practice_id"
  add_index "exercises", ["tutor_id"], name: "index_exercises_on_tutor_id"
  add_index "exercises", ["user_id"], name: "index_exercises_on_user_id"

  create_table "fees", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.integer  "price"
    t.integer  "serial"
    t.datetime "end_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "fees", ["deleted_at"], name: "index_fees_on_deleted_at"
  add_index "fees", ["user_id"], name: "index_fees_on_user_id"

  create_table "histories", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "modelname",  null: false
    t.integer  "entryid",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "histories", ["user_id"], name: "index_histories_on_user_id"

  create_table "homeworks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "classroom_id"
    t.string   "title"
    t.text     "description"
    t.datetime "deleted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "student"
    t.integer  "subject_id"
  end

  add_index "homeworks", ["classroom_id"], name: "index_homeworks_on_classroom_id"
  add_index "homeworks", ["deleted_at"], name: "index_homeworks_on_deleted_at"
  add_index "homeworks", ["subject_id"], name: "index_homeworks_on_subject_id"
  add_index "homeworks", ["user_id"], name: "index_homeworks_on_user_id"

  create_table "justices", force: :cascade do |t|
    t.decimal  "score",                             null: false
    t.text     "remark"
    t.boolean  "activity",           default: true
    t.integer  "user_id"
    t.integer  "evaluation_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "evaluation_user_id"
    t.integer  "practice_id"
    t.datetime "deleted_at"
    t.decimal  "p_score"
  end

  add_index "justices", ["deleted_at"], name: "index_justices_on_deleted_at"
  add_index "justices", ["evaluation_id"], name: "index_justices_on_evaluation_id"
  add_index "justices", ["practice_id"], name: "index_justices_on_practice_id"
  add_index "justices", ["user_id"], name: "index_justices_on_user_id"

  create_table "lessons", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "user_id"
    t.text     "content"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.datetime "deleted_at"
    t.integer  "content_length",       default: 0
  end

  add_index "lessons", ["deleted_at"], name: "index_lessons_on_deleted_at"
  add_index "lessons", ["user_id"], name: "index_lessons_on_user_id"

  create_table "masters", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "masters", ["deleted_at"], name: "index_masters_on_deleted_at"
  add_index "masters", ["user_id"], name: "index_masters_on_user_id"

  create_table "members", force: :cascade do |t|
    t.decimal  "serial"
    t.integer  "user_id"
    t.integer  "classroom_id"
    t.datetime "deleted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "student"
  end

  add_index "members", ["classroom_id"], name: "index_members_on_classroom_id"
  add_index "members", ["deleted_at"], name: "index_members_on_deleted_at"
  add_index "members", ["user_id"], name: "index_members_on_user_id"

  create_table "observations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "student"
    t.string   "point"
    t.text     "mark"
    t.datetime "deleted_at"
    t.integer  "homework_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "observations", ["deleted_at"], name: "index_observations_on_deleted_at"
  add_index "observations", ["homework_id"], name: "index_observations_on_homework_id"
  add_index "observations", ["user_id"], name: "index_observations_on_user_id"

  create_table "onboards", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "begin_at"
    t.datetime "expire_at"
    t.datetime "end_at"
    t.string   "remote_ip"
    t.string   "http_user_agent"
    t.datetime "deleted_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "onboards", ["deleted_at"], name: "index_onboards_on_deleted_at"
  add_index "onboards", ["user_id"], name: "index_onboards_on_user_id"

  create_table "plans", force: :cascade do |t|
    t.decimal  "serial"
    t.integer  "user_id"
    t.integer  "teaching_id"
    t.integer  "tutor_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "deleted_at"
  end

  add_index "plans", ["deleted_at"], name: "index_plans_on_deleted_at"
  add_index "plans", ["teaching_id"], name: "index_plans_on_teaching_id"
  add_index "plans", ["tutor_id"], name: "index_plans_on_tutor_id"
  add_index "plans", ["user_id"], name: "index_plans_on_user_id"

  create_table "players", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.integer  "member_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "players", ["deleted_at"], name: "index_players_on_deleted_at"
  add_index "players", ["member_id"], name: "index_players_on_member_id"
  add_index "players", ["team_id"], name: "index_players_on_team_id"
  add_index "players", ["user_id"], name: "index_players_on_user_id"

  create_table "practices", force: :cascade do |t|
    t.string   "title"
    t.text     "question"
    t.text     "answer"
    t.integer  "user_id"
    t.integer  "tutor_id"
    t.integer  "lesson_id"
    t.boolean  "activate"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.decimal  "score",                  default: 1.0
    t.string   "picture_q_file_name"
    t.string   "picture_q_content_type"
    t.integer  "picture_q_file_size"
    t.datetime "picture_q_updated_at"
    t.string   "picture_a_file_name"
    t.string   "picture_a_content_type"
    t.integer  "picture_a_file_size"
    t.datetime "picture_a_updated_at"
    t.datetime "deleted_at"
    t.text     "material"
    t.string   "labelname"
    t.decimal  "mean",                   default: 0.0
    t.decimal  "mode",                   default: 0.0
    t.decimal  "stdve",                  default: 0.0
    t.decimal  "difficulty",             default: 0.0
  end

  add_index "practices", ["deleted_at"], name: "index_practices_on_deleted_at"
  add_index "practices", ["lesson_id"], name: "index_practices_on_lesson_id"
  add_index "practices", ["tutor_id"], name: "index_practices_on_tutor_id"
  add_index "practices", ["user_id"], name: "index_practices_on_user_id"

  create_table "quiz_items", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "quiz_id"
    t.integer  "practice_id"
    t.boolean  "isright"
    t.datetime "deleted_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "quiz_items", ["deleted_at"], name: "index_quiz_items_on_deleted_at"
  add_index "quiz_items", ["practice_id"], name: "index_quiz_items_on_practice_id"
  add_index "quiz_items", ["quiz_id"], name: "index_quiz_items_on_quiz_id"
  add_index "quiz_items", ["user_id"], name: "index_quiz_items_on_user_id"

  create_table "quizzes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "cardbox_id"
    t.string   "title"
    t.integer  "number"
    t.integer  "repetition"
    t.integer  "duration"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "quizzes", ["cardbox_id"], name: "index_quizzes_on_cardbox_id"
  add_index "quizzes", ["deleted_at"], name: "index_quizzes_on_deleted_at"
  add_index "quizzes", ["user_id"], name: "index_quizzes_on_user_id"

  create_table "receipts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "active_time_before_charge"
    t.integer  "money"
    t.integer  "time_length"
    t.integer  "active_time_after_charge"
    t.integer  "cashier"
    t.datetime "deleted_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "balance"
    t.integer  "price"
  end

  add_index "receipts", ["deleted_at"], name: "index_receipts_on_deleted_at"
  add_index "receipts", ["user_id"], name: "index_receipts_on_user_id"

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], name: "index_roles_on_name"

  create_table "sectionalizations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "classroom_id"
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "sectionalizations", ["classroom_id"], name: "index_sectionalizations_on_classroom_id"
  add_index "sectionalizations", ["deleted_at"], name: "index_sectionalizations_on_deleted_at"
  add_index "sectionalizations", ["user_id"], name: "index_sectionalizations_on_user_id"

  create_table "subjects", force: :cascade do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  add_index "subjects", ["deleted_at"], name: "index_subjects_on_deleted_at"
  add_index "subjects", ["user_id"], name: "index_subjects_on_user_id"

  create_table "teachers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "classroom_id"
    t.integer  "mentor"
    t.datetime "deleted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "subject_id"
  end

  add_index "teachers", ["classroom_id"], name: "index_teachers_on_classroom_id"
  add_index "teachers", ["deleted_at"], name: "index_teachers_on_deleted_at"
  add_index "teachers", ["subject_id"], name: "index_teachers_on_subject_id"
  add_index "teachers", ["user_id"], name: "index_teachers_on_user_id"

  create_table "teachings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "lesson_id"
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  add_index "teachings", ["deleted_at"], name: "index_teachings_on_deleted_at"
  add_index "teachings", ["lesson_id"], name: "index_teachings_on_lesson_id"
  add_index "teachings", ["user_id"], name: "index_teachings_on_user_id"

  create_table "teams", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "sectionalization_id"
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "teams", ["deleted_at"], name: "index_teams_on_deleted_at"
  add_index "teams", ["sectionalization_id"], name: "index_teams_on_sectionalization_id"
  add_index "teams", ["user_id"], name: "index_teams_on_user_id"

  create_table "textbooks", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.decimal  "serial"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "deleted_at"
  end

  add_index "textbooks", ["deleted_at"], name: "index_textbooks_on_deleted_at"
  add_index "textbooks", ["user_id"], name: "index_textbooks_on_user_id"

  create_table "tutors", force: :cascade do |t|
    t.string   "title",                             null: false
    t.decimal  "difficulty",                        null: false
    t.text     "page",                              null: false
    t.integer  "user_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "lesson_id"
    t.string   "picture1_file_name"
    t.string   "picture1_content_type"
    t.integer  "picture1_file_size"
    t.datetime "picture1_updated_at"
    t.string   "picture2_file_name"
    t.string   "picture2_content_type"
    t.integer  "picture2_file_size"
    t.datetime "picture2_updated_at"
    t.datetime "deleted_at"
    t.text     "proviso"
    t.integer  "page_length",           default: 0
  end

  add_index "tutors", ["deleted_at"], name: "index_tutors_on_deleted_at"
  add_index "tutors", ["lesson_id"], name: "index_tutors_on_lesson_id"
  add_index "tutors", ["user_id"], name: "index_tutors_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "active_time",            default: 0
    t.boolean  "is_vip"
  end

  add_index "users", ["active_time"], name: "index_users_on_active_time"
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["is_vip"], name: "index_users_on_is_vip"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"

  create_table "withdraws", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "money"
    t.string   "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  add_index "withdraws", ["deleted_at"], name: "index_withdraws_on_deleted_at"
  add_index "withdraws", ["user_id"], name: "index_withdraws_on_user_id"

end
