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

def split_name(full_name)
  name_array = full_name.split(" ")
  last_name = name_array.shift
  first_name = name_array.join(" ")

  {last_name: last_name, first_name: first_name}
end

def split_parent_name(full_name)
  name_array = full_name.split(" ")
  name_array.shift

  split_name(name_array.join(" "))
end

task :import_students do
  filename = Rails.root.join('lib/assets/confidential/march_2018.csv')
  File.open(filename, 'r') do |file|
    CSV.foreach(file, headers: true) do |student|
      full_name = split_name(student["Name"])

      student_hash = {
        admission_year: student["Year"],
        admission_no: student["SN"],
        registered_at: '',
        current_class: student["Class"],
        surname: full_name[:last_name],
        given_name: full_name[:first_name],
        date_of_birth: format_birthdate(student["Birthdate"]),
        place_of_birth: 'Singapore',
        race: '',
        nric: student["NRIC"],
        citizenship: format_citizenship(student["Nationality"]),
        gender: format_gender(student["Sex"])
      }
      new_student = Student.create(student_hash)

      new_student.past_education_records.create(school_name: student["Previous School"])

      poc_full_name = split_parent_name(student["Parents/Guardian 1"])
      poc1 = {
        relationship: 'Parent/Guardian',
        surname: poc_full_name[:last_name],
        given_name: poc_full_name[:first_name],
        home_number: student["Home Phone"],
        handphone_number: student["Parent/Guardian 1 Contact "]
      }
      new_student.point_of_contacts.create(poc1)

      if student["Parenet/Guardia 2"]
        poc_full_name = split_parent_name(student["Parenet/Guardia 2"])
        poc2 = {
          relationship: 'Parent/Guardian',
          surname: poc_full_name[:last_name],
          given_name: poc_full_name[:first_name],
          home_number: student["Home Phone"],
          handphone_number: student["Parent/Guardian 2 Contact"]
        }
        new_student.point_of_contacts.create(poc2)
      end
    end
  end
end
