class StudentsImporter
  def initialize(filepath)
    @filepath = filepath
  end

  def execute
    File.open(@filepath, 'r') do |file|
      CSV.foreach(file, headers: true) do |student|

        school_class = SchoolClass.first_or_create(
          academic_year: student["Year"],
          name: student["Class"],
          year: student["Class"].split('.').first,
          form_teacher: User.first)
        
        full_name = split_name(student["Name"])

        student_hash = {
          admission_year: student["Year"],
          admission_no: student["SN"],
          surname: full_name[:last_name],
          given_name: full_name[:first_name],
          date_of_birth: format_birthdate(student["Birthdate"]),
          place_of_birth: 'Singapore',
          race: '',
          nric: student["NRIC"],
          citizenship: format_citizenship(student["Nationality"]),
          gender: format_gender(student["Sex"])
        }
        new_student = Student.new(student_hash)
        new_student.save(validate: false)

        new_student.student_classes.create(school_class: school_class)

        new_student.past_education_records.create(school_name: student["Previous School"])

        poc_full_name = split_parent_name(student["Parents/Guardian 1"])
        poc1 = {
          relationship: 'Parent/Guardian',
          salutation: poc_full_name[:salutation],
          surname: poc_full_name[:last_name],
          given_name: poc_full_name[:first_name],
          home_number: student["Home Phone"],
          handphone_number: student["Parent/Guardian 1 Contact"]
        }
        new_student.point_of_contacts.create(poc1)

        if student["Parent/Guardian 2"]
          poc_full_name = split_parent_name(student["Parent/Guardian 2"])
          poc2 = {
            relationship: 'Parent/Guardian',
            salutation: poc_full_name[:salutation],
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

  private

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
    return 'Singaporean' if citizenship == "S'porean"
    citizenship
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
end