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

ActiveRecord::Schema.define(version: 20150408152631) do

  create_table "catalogs", force: :cascade do |t|
    t.decimal  "serial"
    t.integer  "user_id"
    t.integer  "textbook_id"
    t.integer  "lesson_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "catalogs", ["lesson_id"], name: "index_catalogs_on_lesson_id"
  add_index "catalogs", ["textbook_id"], name: "index_catalogs_on_textbook_id"
  add_index "catalogs", ["user_id"], name: "index_catalogs_on_user_id"

  create_table "evaluations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "tutor_id"
    t.integer  "practice_id"
    t.string   "title"
    t.text     "question"
    t.text     "answer"
    t.text     "your_answer"
    t.decimal  "score"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.decimal  "practice_score"
  end

  add_index "evaluations", ["practice_id"], name: "index_evaluations_on_practice_id"
  add_index "evaluations", ["tutor_id"], name: "index_evaluations_on_tutor_id"
  add_index "evaluations", ["user_id"], name: "index_evaluations_on_user_id"

  create_table "histories", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "modelname",  null: false
    t.integer  "entryid",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "histories", ["user_id"], name: "index_histories_on_user_id"

  create_table "justices", force: :cascade do |t|
    t.decimal  "score",                             null: false
    t.text     "remark"
    t.boolean  "activity",           default: true
    t.integer  "user_id"
    t.integer  "evaluation_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "title"
    t.text     "question"
    t.text     "answer"
    t.text     "your_answer"
    t.decimal  "practice_score"
    t.integer  "evaluation_user_id"
    t.integer  "practice_id"
  end

  add_index "justices", ["evaluation_id"], name: "index_justices_on_evaluation_id"
  add_index "justices", ["practice_id"], name: "index_justices_on_practice_id"
  add_index "justices", ["user_id"], name: "index_justices_on_user_id"

  create_table "lessons", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.text     "content"
  end

  add_index "lessons", ["user_id"], name: "index_lessons_on_user_id"

  create_table "plans", force: :cascade do |t|
    t.decimal  "serail"
    t.integer  "user_id"
    t.integer  "teaching_id"
    t.integer  "tutor_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "plans", ["teaching_id"], name: "index_plans_on_teaching_id"
  add_index "plans", ["tutor_id"], name: "index_plans_on_tutor_id"
  add_index "plans", ["user_id"], name: "index_plans_on_user_id"

  create_table "practices", force: :cascade do |t|
    t.string   "title"
    t.text     "question"
    t.text     "answer"
    t.integer  "user_id"
    t.integer  "tutor_id"
    t.integer  "lesson_id"
    t.boolean  "activate"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.decimal  "score",      default: 1.0
  end

  add_index "practices", ["lesson_id"], name: "index_practices_on_lesson_id"
  add_index "practices", ["tutor_id"], name: "index_practices_on_tutor_id"
  add_index "practices", ["user_id"], name: "index_practices_on_user_id"

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], name: "index_roles_on_name"

  create_table "teachings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "lesson_id"
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "teachings", ["lesson_id"], name: "index_teachings_on_lesson_id"
  add_index "teachings", ["user_id"], name: "index_teachings_on_user_id"

  create_table "textbooks", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.decimal  "serial"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "textbooks", ["user_id"], name: "index_textbooks_on_user_id"

  create_table "tutors", force: :cascade do |t|
    t.string   "title",      null: false
    t.decimal  "difficulty", null: false
    t.text     "page",       null: false
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "lesson_id"
  end

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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"

end
