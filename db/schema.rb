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

ActiveRecord::Schema.define(version: 20190126154825) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agreements", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_agreements_on_comment_id", using: :btree
    t.index ["deleted_at"], name: "index_agreements_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_agreements_on_user_id", using: :btree
  end

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
    t.index ["classroom_id"], name: "index_badrecords_on_classroom_id", using: :btree
    t.index ["deleted_at"], name: "index_badrecords_on_deleted_at", using: :btree
    t.index ["subject_id"], name: "index_badrecords_on_subject_id", using: :btree
    t.index ["user_id"], name: "index_badrecords_on_user_id", using: :btree
  end

  create_table "booklists", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "textbook_id"
    t.decimal  "serial"
    t.datetime "deleted_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["deleted_at"], name: "index_booklists_on_deleted_at", using: :btree
    t.index ["textbook_id"], name: "index_booklists_on_textbook_id", using: :btree
    t.index ["user_id"], name: "index_booklists_on_user_id", using: :btree
  end

  create_table "cadres", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "position"
    t.integer  "member_id"
    t.datetime "deleted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "classroom_id"
    t.integer  "team_id"
    t.index ["classroom_id"], name: "index_cadres_on_classroom_id", using: :btree
    t.index ["member_id"], name: "index_cadres_on_member_id", using: :btree
    t.index ["team_id"], name: "index_cadres_on_team_id", using: :btree
    t.index ["user_id"], name: "index_cadres_on_user_id", using: :btree
  end

  create_table "cardboxes", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "share",      default: false
    t.integer  "lesson_id"
    t.index ["deleted_at"], name: "index_cardboxes_on_deleted_at", using: :btree
    t.index ["lesson_id"], name: "index_cardboxes_on_lesson_id", using: :btree
    t.index ["user_id"], name: "index_cardboxes_on_user_id", using: :btree
  end

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
    t.index ["cardbox_id"], name: "index_cards_on_cardbox_id", using: :btree
    t.index ["deleted_at"], name: "index_cards_on_deleted_at", using: :btree
    t.index ["practice_id"], name: "index_cards_on_practice_id", using: :btree
    t.index ["user_id"], name: "index_cards_on_user_id", using: :btree
  end

  create_table "cashiers", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_cashiers_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_cashiers_on_user_id", using: :btree
  end

  create_table "catalogs", force: :cascade do |t|
    t.decimal  "serial"
    t.integer  "user_id"
    t.integer  "textbook_id"
    t.integer  "lesson_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_catalogs_on_deleted_at", using: :btree
    t.index ["lesson_id"], name: "index_catalogs_on_lesson_id", using: :btree
    t.index ["textbook_id"], name: "index_catalogs_on_textbook_id", using: :btree
    t.index ["user_id"], name: "index_catalogs_on_user_id", using: :btree
  end

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
    t.index ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
    t.index ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree
  end

  create_table "classgroupscores", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.decimal  "score"
    t.string   "domain"
    t.string   "memo"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_classgroupscores_on_deleted_at", using: :btree
    t.index ["team_id"], name: "index_classgroupscores_on_team_id", using: :btree
    t.index ["user_id"], name: "index_classgroupscores_on_user_id", using: :btree
  end

  create_table "classpersonscores", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "member_id"
    t.decimal  "score"
    t.integer  "classgroupscore_id"
    t.datetime "deleted_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["classgroupscore_id"], name: "index_classpersonscores_on_classgroupscore_id", using: :btree
    t.index ["deleted_at"], name: "index_classpersonscores_on_deleted_at", using: :btree
    t.index ["member_id"], name: "index_classpersonscores_on_member_id", using: :btree
    t.index ["user_id"], name: "index_classpersonscores_on_user_id", using: :btree
  end

  create_table "classrooms", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.boolean  "end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_classrooms_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_classrooms_on_user_id", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "deleted_at"
    t.text     "content"
    t.integer  "lesson_id"
    t.integer  "sentence_id"
    t.integer  "word_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["deleted_at"], name: "index_comments_on_deleted_at", using: :btree
    t.index ["lesson_id"], name: "index_comments_on_lesson_id", using: :btree
    t.index ["sentence_id"], name: "index_comments_on_sentence_id", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
    t.index ["word_id"], name: "index_comments_on_word_id", using: :btree
  end

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
    t.index ["deleted_at"], name: "index_complaints_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_complaints_on_user_id", using: :btree
  end

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
    t.index ["classroom_id"], name: "index_discussions_on_classroom_id", using: :btree
    t.index ["deleted_at"], name: "index_discussions_on_deleted_at", using: :btree
    t.index ["lesson_id"], name: "index_discussions_on_lesson_id", using: :btree
    t.index ["teaching_id"], name: "index_discussions_on_teaching_id", using: :btree
    t.index ["textbook_id"], name: "index_discussions_on_textbook_id", using: :btree
    t.index ["user_id"], name: "index_discussions_on_user_id", using: :btree
  end

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
    t.datetime "end_at"
    t.integer  "papertest_id"
    t.index ["deleted_at"], name: "index_evaluations_on_deleted_at", using: :btree
    t.index ["lesson_id"], name: "index_evaluations_on_lesson_id", using: :btree
    t.index ["papertest_id"], name: "index_evaluations_on_papertest_id", using: :btree
    t.index ["practice_id"], name: "index_evaluations_on_practice_id", using: :btree
    t.index ["user_id"], name: "index_evaluations_on_user_id", using: :btree
  end

  create_table "examrooms", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "classroom_id"
    t.integer  "paper_id"
    t.datetime "deleted_at"
    t.boolean  "isactive"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["classroom_id"], name: "index_examrooms_on_classroom_id", using: :btree
    t.index ["deleted_at"], name: "index_examrooms_on_deleted_at", using: :btree
    t.index ["paper_id"], name: "index_examrooms_on_paper_id", using: :btree
    t.index ["user_id"], name: "index_examrooms_on_user_id", using: :btree
  end

  create_table "exercises", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "tutor_id"
    t.decimal  "serial"
    t.integer  "practice_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_exercises_on_deleted_at", using: :btree
    t.index ["practice_id"], name: "index_exercises_on_practice_id", using: :btree
    t.index ["tutor_id"], name: "index_exercises_on_tutor_id", using: :btree
    t.index ["user_id"], name: "index_exercises_on_user_id", using: :btree
  end

  create_table "fees", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.integer  "price"
    t.integer  "serial"
    t.datetime "end_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_fees_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_fees_on_user_id", using: :btree
  end

  create_table "histories", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "modelname",  null: false
    t.integer  "entryid",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_histories_on_user_id", using: :btree
  end

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
    t.index ["classroom_id"], name: "index_homeworks_on_classroom_id", using: :btree
    t.index ["deleted_at"], name: "index_homeworks_on_deleted_at", using: :btree
    t.index ["subject_id"], name: "index_homeworks_on_subject_id", using: :btree
    t.index ["user_id"], name: "index_homeworks_on_user_id", using: :btree
  end

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
    t.index ["deleted_at"], name: "index_justices_on_deleted_at", using: :btree
    t.index ["evaluation_id"], name: "index_justices_on_evaluation_id", using: :btree
    t.index ["practice_id"], name: "index_justices_on_practice_id", using: :btree
    t.index ["user_id"], name: "index_justices_on_user_id", using: :btree
  end

  create_table "lesson_practices", force: :cascade do |t|
    t.integer  "lesson_id"
    t.integer  "practice_id"
    t.datetime "deleted_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["deleted_at"], name: "index_lesson_practices_on_deleted_at", using: :btree
    t.index ["lesson_id"], name: "index_lesson_practices_on_lesson_id", using: :btree
    t.index ["practice_id"], name: "index_lesson_practices_on_practice_id", using: :btree
  end

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
    t.integer  "time"
    t.string   "author"
    t.string   "source"
    t.index ["author"], name: "index_lessons_on_author", using: :btree
    t.index ["deleted_at"], name: "index_lessons_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_lessons_on_user_id", using: :btree
  end

  create_table "masters", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_masters_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_masters_on_user_id", using: :btree
  end

  create_table "meanings", force: :cascade do |t|
    t.text     "content"
    t.integer  "word_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_meanings_on_deleted_at", using: :btree
    t.index ["word_id"], name: "index_meanings_on_word_id", using: :btree
  end

  create_table "members", force: :cascade do |t|
    t.decimal  "serial"
    t.integer  "user_id"
    t.integer  "classroom_id"
    t.datetime "deleted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "student"
    t.index ["classroom_id"], name: "index_members_on_classroom_id", using: :btree
    t.index ["deleted_at"], name: "index_members_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_members_on_user_id", using: :btree
  end

  create_table "observations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "student"
    t.string   "point"
    t.text     "mark"
    t.datetime "deleted_at"
    t.integer  "homework_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["deleted_at"], name: "index_observations_on_deleted_at", using: :btree
    t.index ["homework_id"], name: "index_observations_on_homework_id", using: :btree
    t.index ["user_id"], name: "index_observations_on_user_id", using: :btree
  end

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
    t.index ["deleted_at"], name: "index_onboards_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_onboards_on_user_id", using: :btree
  end

  create_table "paces", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "roadmap_id"
    t.integer  "lesson_id"
    t.decimal  "serial"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_paces_on_deleted_at", using: :btree
    t.index ["lesson_id"], name: "index_paces_on_lesson_id", using: :btree
    t.index ["roadmap_id"], name: "index_paces_on_roadmap_id", using: :btree
    t.index ["user_id"], name: "index_paces_on_user_id", using: :btree
  end

  create_table "paperitems", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "paper_id"
    t.integer  "practice_id"
    t.decimal  "score"
    t.datetime "deleted_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.decimal  "serial"
    t.text     "memo"
    t.index ["deleted_at"], name: "index_paperitems_on_deleted_at", using: :btree
    t.index ["paper_id"], name: "index_paperitems_on_paper_id", using: :btree
    t.index ["practice_id"], name: "index_paperitems_on_practice_id", using: :btree
    t.index ["user_id"], name: "index_paperitems_on_user_id", using: :btree
  end

  create_table "papers", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.integer  "duration"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_papers_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_papers_on_user_id", using: :btree
  end

  create_table "papertests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "paper_id"
    t.datetime "end_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_papertests_on_deleted_at", using: :btree
    t.index ["paper_id"], name: "index_papertests_on_paper_id", using: :btree
    t.index ["user_id"], name: "index_papertests_on_user_id", using: :btree
  end

  create_table "phonetic_notations", force: :cascade do |t|
    t.integer  "phonetic_id"
    t.integer  "word_id"
    t.datetime "deleted_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["deleted_at"], name: "index_phonetic_notations_on_deleted_at", using: :btree
    t.index ["phonetic_id"], name: "index_phonetic_notations_on_phonetic_id", using: :btree
    t.index ["word_id"], name: "index_phonetic_notations_on_word_id", using: :btree
  end

  create_table "phonetics", force: :cascade do |t|
    t.string   "content"
    t.string   "label"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "rhyme"
    t.index ["deleted_at"], name: "index_phonetics_on_deleted_at", using: :btree
  end

  create_table "plans", force: :cascade do |t|
    t.decimal  "serial"
    t.integer  "user_id"
    t.integer  "teaching_id"
    t.integer  "tutor_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_plans_on_deleted_at", using: :btree
    t.index ["teaching_id"], name: "index_plans_on_teaching_id", using: :btree
    t.index ["tutor_id"], name: "index_plans_on_tutor_id", using: :btree
    t.index ["user_id"], name: "index_plans_on_user_id", using: :btree
  end

  create_table "players", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.integer  "member_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_players_on_deleted_at", using: :btree
    t.index ["member_id"], name: "index_players_on_member_id", using: :btree
    t.index ["team_id"], name: "index_players_on_team_id", using: :btree
    t.index ["user_id"], name: "index_players_on_user_id", using: :btree
  end

  create_table "practice_parsers", force: :cascade do |t|
    t.integer  "practice_id"
    t.integer  "word_id"
    t.datetime "deleted_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["deleted_at"], name: "index_practice_parsers_on_deleted_at", using: :btree
    t.index ["practice_id"], name: "index_practice_parsers_on_practice_id", using: :btree
    t.index ["word_id"], name: "index_practice_parsers_on_word_id", using: :btree
  end

  create_table "practices", force: :cascade do |t|
    t.string   "title"
    t.text     "question"
    t.text     "answer"
    t.integer  "user_id"
    t.integer  "tutor_id"
    t.integer  "lesson_id"
    t.boolean  "activate"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.decimal  "score",                  default: "1.0"
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
    t.decimal  "mean",                   default: "0.0"
    t.decimal  "mode",                   default: "0.0"
    t.decimal  "stdve",                  default: "0.0"
    t.decimal  "difficulty",             default: "0.0"
    t.index ["deleted_at"], name: "index_practices_on_deleted_at", using: :btree
    t.index ["lesson_id"], name: "index_practices_on_lesson_id", using: :btree
    t.index ["tutor_id"], name: "index_practices_on_tutor_id", using: :btree
    t.index ["user_id"], name: "index_practices_on_user_id", using: :btree
  end

  create_table "quiz_items", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "quiz_id"
    t.integer  "practice_id"
    t.boolean  "isright"
    t.datetime "deleted_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["deleted_at"], name: "index_quiz_items_on_deleted_at", using: :btree
    t.index ["practice_id"], name: "index_quiz_items_on_practice_id", using: :btree
    t.index ["quiz_id"], name: "index_quiz_items_on_quiz_id", using: :btree
    t.index ["user_id"], name: "index_quiz_items_on_user_id", using: :btree
  end

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
    t.index ["cardbox_id"], name: "index_quizzes_on_cardbox_id", using: :btree
    t.index ["deleted_at"], name: "index_quizzes_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_quizzes_on_user_id", using: :btree
  end

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
    t.index ["deleted_at"], name: "index_receipts_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_receipts_on_user_id", using: :btree
  end

  create_table "roadmaps", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "deleted_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "textbook_id"
    t.index ["deleted_at"], name: "index_roadmaps_on_deleted_at", using: :btree
    t.index ["textbook_id"], name: "index_roadmaps_on_textbook_id", using: :btree
    t.index ["user_id"], name: "index_roadmaps_on_user_id", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
    t.index ["name"], name: "index_roles_on_name", using: :btree
  end

  create_table "sectionalizations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "classroom_id"
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["classroom_id"], name: "index_sectionalizations_on_classroom_id", using: :btree
    t.index ["deleted_at"], name: "index_sectionalizations_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_sectionalizations_on_user_id", using: :btree
  end

  create_table "sentences", force: :cascade do |t|
    t.integer  "lesson_id"
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_sentences_on_deleted_at", using: :btree
    t.index ["lesson_id"], name: "index_sentences_on_lesson_id", using: :btree
  end

  create_table "subjects", force: :cascade do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.index ["deleted_at"], name: "index_subjects_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_subjects_on_user_id", using: :btree
  end

  create_table "teachers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "classroom_id"
    t.integer  "mentor"
    t.datetime "deleted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "subject_id"
    t.index ["classroom_id"], name: "index_teachers_on_classroom_id", using: :btree
    t.index ["deleted_at"], name: "index_teachers_on_deleted_at", using: :btree
    t.index ["subject_id"], name: "index_teachers_on_subject_id", using: :btree
    t.index ["user_id"], name: "index_teachers_on_user_id", using: :btree
  end

  create_table "teachings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "lesson_id"
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_teachings_on_deleted_at", using: :btree
    t.index ["lesson_id"], name: "index_teachings_on_lesson_id", using: :btree
    t.index ["user_id"], name: "index_teachings_on_user_id", using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "sectionalization_id"
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["deleted_at"], name: "index_teams_on_deleted_at", using: :btree
    t.index ["sectionalization_id"], name: "index_teams_on_sectionalization_id", using: :btree
    t.index ["user_id"], name: "index_teams_on_user_id", using: :btree
  end

  create_table "textbooks", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.decimal  "serial"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_textbooks_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_textbooks_on_user_id", using: :btree
  end

  create_table "tutors", force: :cascade do |t|
    t.string   "title",                             null: false
    t.decimal  "difficulty",                        null: false
    t.text     "page"
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
    t.index ["deleted_at"], name: "index_tutors_on_deleted_at", using: :btree
    t.index ["lesson_id"], name: "index_tutors_on_lesson_id", using: :btree
    t.index ["user_id"], name: "index_tutors_on_user_id", using: :btree
  end

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
    t.index ["active_time"], name: "index_users_on_active_time", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["is_vip"], name: "index_users_on_is_vip", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree
  end

  create_table "withdraws", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "money"
    t.string   "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_withdraws_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_withdraws_on_user_id", using: :btree
  end

  create_table "word_parsers", force: :cascade do |t|
    t.integer  "word_id"
    t.integer  "lesson_id"
    t.datetime "deleted_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "sentence_id"
    t.index ["deleted_at"], name: "index_word_parsers_on_deleted_at", using: :btree
    t.index ["lesson_id"], name: "index_word_parsers_on_lesson_id", using: :btree
    t.index ["sentence_id"], name: "index_word_parsers_on_sentence_id", using: :btree
    t.index ["word_id"], name: "index_word_parsers_on_word_id", using: :btree
  end

  create_table "wordmaps", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "roadmap_id"
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_wordmaps_on_deleted_at", using: :btree
    t.index ["roadmap_id"], name: "index_wordmaps_on_roadmap_id", using: :btree
    t.index ["user_id"], name: "index_wordmaps_on_user_id", using: :btree
  end

  create_table "wordorders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "wordmap_id"
    t.integer  "word_id"
    t.integer  "serial"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_wordorders_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_wordorders_on_user_id", using: :btree
    t.index ["word_id"], name: "index_wordorders_on_word_id", using: :btree
    t.index ["wordmap_id"], name: "index_wordorders_on_wordmap_id", using: :btree
  end

  create_table "words", force: :cascade do |t|
    t.string   "name"
    t.integer  "length"
    t.datetime "deleted_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "md1"
    t.integer  "md2"
    t.integer  "md3"
    t.integer  "md4"
    t.boolean  "is_meanful"
    t.integer  "md5"
    t.integer  "md6"
    t.integer  "md7"
    t.integer  "md8"
    t.integer  "phonetics_count", default: 0
    t.integer  "meanings_count",  default: 0
    t.index ["deleted_at"], name: "index_words_on_deleted_at", using: :btree
    t.index ["md1"], name: "index_words_on_md1", using: :btree
    t.index ["md2"], name: "index_words_on_md2", using: :btree
    t.index ["md3"], name: "index_words_on_md3", using: :btree
    t.index ["md4"], name: "index_words_on_md4", using: :btree
    t.index ["md5"], name: "index_words_on_md5", using: :btree
    t.index ["md6"], name: "index_words_on_md6", using: :btree
    t.index ["md7"], name: "index_words_on_md7", using: :btree
    t.index ["md8"], name: "index_words_on_md8", using: :btree
  end

  create_table "words_reports", force: :cascade do |t|
    t.integer  "lesson_id"
    t.string   "md"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_words_reports_on_deleted_at", using: :btree
    t.index ["lesson_id"], name: "index_words_reports_on_lesson_id", using: :btree
  end

  add_foreign_key "agreements", "comments"
  add_foreign_key "agreements", "users"
  add_foreign_key "booklists", "textbooks"
  add_foreign_key "booklists", "users"
  add_foreign_key "comments", "lessons"
  add_foreign_key "comments", "sentences"
  add_foreign_key "comments", "users"
  add_foreign_key "comments", "words"
  add_foreign_key "lesson_practices", "lessons"
  add_foreign_key "lesson_practices", "practices"
  add_foreign_key "meanings", "words"
  add_foreign_key "paces", "lessons"
  add_foreign_key "paces", "roadmaps"
  add_foreign_key "paces", "users"
  add_foreign_key "phonetic_notations", "phonetics"
  add_foreign_key "phonetic_notations", "words"
  add_foreign_key "practice_parsers", "practices"
  add_foreign_key "practice_parsers", "words"
  add_foreign_key "roadmaps", "textbooks"
  add_foreign_key "roadmaps", "users"
  add_foreign_key "wordmaps", "roadmaps"
  add_foreign_key "wordmaps", "users"
  add_foreign_key "wordorders", "users"
  add_foreign_key "wordorders", "wordmaps"
  add_foreign_key "wordorders", "words"
end
