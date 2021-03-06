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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110417102519) do

  create_table "blinds", :force => true do |t|
    t.integer  "student_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comment_rating_students", :force => true do |t|
    t.integer  "comment_id"
    t.integer  "student_id"
    t.integer  "mark"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "post_id"
    t.integer  "student_id"
    t.integer  "comment_id"
    t.text     "content"
    t.integer  "rating",     :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "days", :force => true do |t|
    t.integer  "day"
    t.integer  "month"
    t.integer  "year"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "day_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "headman_auls", :force => true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "husers", :force => true do |t|
    t.string   "login"
    t.string   "password"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.text     "content"
    t.integer  "student_id"
    t.integer  "student_from_id"
    t.boolean  "new",             :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "novelties", :force => true do |t|
    t.integer  "student_id"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "post_rating_students", :force => true do |t|
    t.integer  "post_id"
    t.integer  "student_id"
    t.integer  "mark"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.integer  "student_id"
    t.text     "content"
    t.integer  "rating"
    t.string   "title",                     :default => "Title"
    t.string   "annotation", :limit => 256, :default => "Annotation"
    t.integer  "section_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", :force => true do |t|
    t.string   "title"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "group",                     :limit => 40,  :default => "6361"
    t.datetime "last_visit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.integer  "rating",                                   :default => 0
    t.string   "second_name",               :limit => 100
    t.string   "last_name",                 :limit => 100
    t.boolean  "admin",                                    :default => false
    t.boolean  "headman",                                  :default => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "prev_visit",                               :default => '2011-04-18 18:45:13'
  end

  add_index "students", ["login"], :name => "index_students_on_login", :unique => true

end
