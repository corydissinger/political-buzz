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

ActiveRecord::Schema.define(:version => 20121013230625) do

  create_table "articles", :force => true do |t|
    t.integer "category_id"
    t.string  "url"
  end

  add_index "articles", ["url"], :name => "index_articles_on_url", :unique => true

  create_table "categories", :force => true do |t|
    t.string "name"
  end

  add_index "categories", ["name"], :name => "index_categories_on_name", :unique => true

  create_table "categories_statements", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "statement_id"
  end

  add_index "categories_statements", ["category_id", "statement_id"], :name => "index_categories_statements_on_category_id_and_statement_id", :unique => true

  create_table "statements", :force => true do |t|
    t.integer "topic_id"
    t.text    "transcript"
    t.string  "url"
    t.string  "speaker"
    t.date    "date"
  end

  create_table "topics", :force => true do |t|
    t.string  "name"
    t.integer "count"
  end

  add_index "topics", ["name"], :name => "index_topics_on_name", :unique => true

end
