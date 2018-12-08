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

  { last_name: last_name, first_name: first_name }
end

def split_parent_name(full_name)
  name_array = full_name.split(" ")
  salutation = name_array.shift

  new_full_name = split_name(name_array.join(" "))
  new_full_name[:salutation] = salutation

  new_full_name
end

def empty_row?(row)
  # row.uniq.join('').length == 0
  uniq_cols = row.uniq
  uniq_cols.count == 1 && uniq_cols[0].nil?
end

def school_header?(i)
  i == 2 || i == 3 || i ==4
end

def class_info?(i)
  i == 6
end

def header?(i)
  i == 8
end

def build_class_record(row)
  class_name = row[1].strip.gsub(/^.+?(:)/, '')
  teacher_name = row[5].strip.gsub(/^.+?(\s)/, '')
  academic_year = row[12].strip.to_i

  teacher = User.where(name: teacher_name).first_or_create! do |user|
    user.email = teacher_name.downcase.gsub(/\s/, '_') + '@mvs.edu.sg'
    user.password = 'password1234'
    user.role = Role.find_by(name: 'teacher')
  end

  SchoolClass.where(name: class_name).first_or_create! do |school_class|
    school_class.name = class_name
    school_class.academic_year = academic_year
    school_class.year = class_name[0].to_i
    school_class.form_teacher = teacher
  end
end

def col
  {
    student_no: 0,
    name: 1,
    gender: 2,
    admission_no: 4,
    date_of_birth: 5,
    nric: 6,
    citizenship: 7,
    parent_name: 8,
    parent_occupation: 9,
    contact_no: 10,
    address: 11,
    postal_code: 12
  }
end

def create_record(student, current_class)
  return if student.count < 1
  admission_no = student[0][col[:admission_no]]
  admission_year = admission_no.split('/').last.strip
  
  full_name = split_parent_name("#{student[0][col[:name]]}" + "#{student[1][col[:name]]}")

  student_hash = {
    admission_year: admission_year,
    admission_no: admission_no,
    surname: full_name[:last_name],
    given_name: full_name[:first_name],
    date_of_birth: format_birthdate(student[0][col[:date_of_birth]]),
    place_of_birth: 'Singapore',
    race: student[3][col[:citizenship]],
    nric: student[0][col[:nric]],
    citizenship: format_citizenship(student[0][col[:citizenship]]),
    gender: format_gender(student[0][col[:gender]])
  }
  new_student = Student.new(student_hash)
  # new_student.save(validate: false)

  new_student.student_classes.create(school_class: current_class)
  
  new_student.past_education_records.create(school_name: student[3][col[:name]])

end

task :import_yammy_version do
  filename = Rails.root.join('lib/assets/confidential/1_1_2017N.csv')
  File.open(filename, 'r') do |file|
    current_student = []
    current_class = nil
    CSV.foreach(file).each_with_index do |row, i|
      next if empty_row?(row)|| school_header?(i) || header?(i)
      if class_info?(i)
        current_class = build_class_record(row)
        next
      end

      if row[col[:student_no]]
        create_record(current_student, current_class)
        current_student = []
      end

      current_student << row
    end
  end
end
