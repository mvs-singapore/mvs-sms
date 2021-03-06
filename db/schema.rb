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

ActiveRecord::Schema.define(version: 2018_12_15_031743) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachments", force: :cascade do |t|
    t.string "document_type"
    t.string "filename"
    t.string "notes"
    t.bigint "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_attachments_on_student_id"
  end

  create_table "disabilities", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "financial_assistance_records", force: :cascade do |t|
    t.string "assistance_type"
    t.string "year_obtained"
    t.string "duration"
    t.bigint "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_financial_assistance_records_on_student_id"
  end

  create_table "internship_companies", force: :cascade do |t|
    t.string "name", null: false
    t.text "address"
    t.string "postal_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "internship_records", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "internship_company_id"
    t.bigint "internship_supervisor_id"
    t.date "from_date", null: false
    t.date "to_date"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["internship_company_id"], name: "index_internship_records_on_internship_company_id"
    t.index ["internship_supervisor_id"], name: "index_internship_records_on_internship_supervisor_id"
    t.index ["student_id"], name: "index_internship_records_on_student_id"
  end

  create_table "internship_supervisors", force: :cascade do |t|
    t.string "name", null: false
    t.string "email"
    t.string "contact_number", null: false
    t.bigint "internship_company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["internship_company_id"], name: "index_internship_supervisors_on_internship_company_id"
  end

  create_table "medical_conditions", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "past_education_records", force: :cascade do |t|
    t.string "school_name", null: false
    t.date "from_date"
    t.date "to_date"
    t.string "qualification"
    t.integer "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "highest_qualification"
    t.index ["student_id"], name: "index_past_education_records_on_student_id"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "point_of_contacts", force: :cascade do |t|
    t.string "surname"
    t.string "given_name"
    t.text "address"
    t.string "postal_code"
    t.string "race"
    t.string "dialect"
    t.string "languages_spoken"
    t.string "id_number"
    t.integer "id_type"
    t.date "date_of_birth"
    t.string "place_of_birth"
    t.string "nationality"
    t.string "occupation"
    t.string "home_number"
    t.string "handphone_number"
    t.string "office_number"
    t.string "relationship"
    t.bigint "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "salutation"
    t.string "email"
    t.index ["student_id"], name: "index_point_of_contacts_on_student_id"
  end

  create_table "remarks", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "user_id"
    t.date "event_date", null: false
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category", null: false
    t.index ["student_id"], name: "index_remarks_on_student_id"
    t.index ["user_id"], name: "index_remarks_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "super_admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "school_classes", force: :cascade do |t|
    t.integer "academic_year"
    t.string "name"
    t.integer "year"
    t.integer "form_teacher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["form_teacher_id"], name: "index_school_classes_on_form_teacher_id"
  end

  create_table "student_classes", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "school_class_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_class_id"], name: "index_student_classes_on_school_class_id"
    t.index ["student_id"], name: "index_student_classes_on_student_id"
  end

  create_table "student_disabilities", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "disability_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["disability_id"], name: "index_student_disabilities_on_disability_id"
    t.index ["student_id"], name: "index_student_disabilities_on_student_id"
  end

  create_table "student_medical_conditions", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "medical_condition_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medical_condition_id"], name: "index_student_medical_conditions_on_medical_condition_id"
    t.index ["student_id"], name: "index_student_medical_conditions_on_student_id"
  end

  create_table "student_status_histories", force: :cascade do |t|
    t.bigint "student_id"
    t.string "status", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_student_status_histories_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.integer "admission_year", null: false
    t.string "admission_no"
    t.date "registered_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "current_class"
    t.string "status", default: "new_admission", null: false
    t.string "referred_by"
    t.text "referral_notes"
    t.string "surname", null: false
    t.string "given_name", null: false
    t.date "date_of_birth", null: false
    t.string "place_of_birth", default: "Singapore", null: false
    t.string "race"
    t.string "nric", null: false
    t.string "citizenship", default: "Singaporean", null: false
    t.integer "gender", null: false
    t.string "sadeaf_client_reg_no"
    t.text "medication_needed"
    t.text "allergies"
    t.integer "tshirt_size"
    t.string "image_id"
    t.string "home_number"
    t.string "mobile_number"
    t.string "address"
    t.string "postal_code"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", default: "MVS User", null: false
    t.bigint "role_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "attachments", "students"
  add_foreign_key "financial_assistance_records", "students"
  add_foreign_key "internship_records", "internship_companies"
  add_foreign_key "internship_records", "internship_supervisors"
  add_foreign_key "internship_records", "students"
  add_foreign_key "internship_supervisors", "internship_companies"
  add_foreign_key "point_of_contacts", "students"
  add_foreign_key "remarks", "students"
  add_foreign_key "remarks", "users"
  add_foreign_key "student_classes", "school_classes"
  add_foreign_key "student_classes", "students"
  add_foreign_key "student_disabilities", "disabilities"
  add_foreign_key "student_disabilities", "students"
  add_foreign_key "student_medical_conditions", "medical_conditions"
  add_foreign_key "student_medical_conditions", "students"
  add_foreign_key "student_status_histories", "students"
  add_foreign_key "users", "roles"
end
