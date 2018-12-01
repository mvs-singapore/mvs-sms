# 1. Name. given_name, first_name format available?
# 2. Classify disability, medication_needed, medical_condition, allergies
# 3. Place of birth same as nationality? (not in excel sheet)
# 4. Admission no generation (? not in the excel sheet)
# 5. Details required:
#     - registered_at ()
#     - @ referred_by (no such data in Excel - can remove valdiation)
#     - race (need this for validation)
#     - @ duration of previous school (Remove validation)
#     - parent,guardian relationship (actual relationship needed)

desc "Import students from CSV"

def format_birthdate(birthdate)
  return unless birthdate
  day, month, year = birthdate.split('-')
  full_year = (year.to_i + 20 > 100) ? "19#{year}" : "20#{year}"

  Date.strptime("#{day}-#{month}-#{full_year}", '%d-%b-%Y')
end

def format_gender(gender)
  return unless gender
  mapper = { 'F' => 0, 'M' => 1 }
  mapper[gender]
end

def format_citizenship(citizenship)
  return unless citizenship
  mapper = { "S'porean" => 'Singaporean' }
  mapper[citizenship]
end

task :import_students do
  filename = Rails.root.join('lib/assets/confidential/march_2018.csv')
  File.open(filename, 'r') do |file|
    CSV.foreach(file, headers: true) do |student|
      student_hash = {}
      student_hash[:admission_year] = student["Year"]
      student_hash[:admission_no] = student["SN"]
      student_hash[:registered_at]
      student_hash[:current_class] = student["Class"]
      student_hash[:status]
      student_hash[:referred_by]
      student_hash[:surname]
      student_hash[:given_name]
      student_hash[:date_of_birth] = format_birthdate(student["Birthdate"])
      student_hash[:place_of_birth]
      student_hash[:race]
      student_hash[:nric] = student["NRIC"]
      student_hash[:citizenship] = format_citizenship(student["Nationality"])
      student_hash[:gender] = format_gender(student["Sex"])
      student_hash[:medication_needed]
      student_hash[:allergies]
      new_student = Student.new(student_hash)

      # disability[:title]
      # medical_condition[:title]

      # past_education_record[:school_name] = student["Previous School"]
      # past_education_record[:from_date]
      # past_education_record[:to_date]

      # point_of_contact[:surname]
      # point_of_contact[:given_name]
      # point_of_contact[:address] = student["Home Address"]
      # point_of_contact[:postal_code]
      # point_of_contact[:race]
      # point_of_contact[:dialect]
      # point_of_contact[:languages_spoken]
      # point_of_contact[:id_number]
      # point_of_contact[:id_type]
      # point_of_contact[:date_of_birth]
      # point_of_contact[:place_of_birth]
      # point_of_contact[:nationality]
      # point_of_contact[:occupation]
      # point_of_contact[:home_number]
      # point_of_contact[:handphone_number]
      # point_of_contact[:office_number]
      # point_of_contact[:relationship]
    end
  end
end
