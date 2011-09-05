class CreateTranslations < ActiveRecord::Migration
  def self.up
    create_table "translate_histories", :force => true do |t|
      t.integer  "translation_id"
      t.string   "lang"
      t.integer  "string_id"
      t.text     "content"
      t.string   "status"
      t.string   "votes"
      t.integer  "submitter_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "translate_histories", ["status", "submitter_id"], :name => "status_submitter_translation_histories"

    create_table "translate_improvements", :force => true do |t|
      t.integer  "submitter_id"
      t.integer  "translation_id"
      t.text     "content"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "translate_improvements", ["submitter_id", "translation_id"], :name => "translate_improvements_submitter_id_translation_id", :unique => true

    create_table "translate_notifications", :force => true do |t|
      t.integer  "user_id"
      t.string   "language"
      t.boolean  "enabled"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "translate_statistics", :force => true do |t|
      t.string  "lang"
      t.integer "untranslated", :default => 0
      t.integer "needs_review", :default => 0
      t.integer "reviewed",     :default => 0
      t.integer "improvement",  :default => 0
    end

    create_table "translate_strings", :force => true do |t|
      t.string   "prefix"
      t.string   "suffix"
      t.text     "value"
      t.text     "context"
      t.boolean  "is_new",     :default => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "translate_strings", ["prefix", "suffix"], :name => "prefix_suffix_translate_strings", :unique => true

    create_table "translate_translations", :force => true do |t|
      t.integer  "string_id"
      t.string   "lang"
      t.text     "content"
      t.string   "status"
      t.string   "votes"
      t.integer  "submitter_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "translate_translations", ["string_id", "lang"], :name => "string_id_and_lang", :unique => true

    create_table "translate_users", :force => true do |t|
      t.integer "user_id"
      t.string  "right"
    end
    
  end

  def self.down
  end
end
