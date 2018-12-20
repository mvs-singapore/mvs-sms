class StudentsImporter
  def self.execute(filepath)
    File.open(filepath, 'r') do |file|
      CSV.foreach(file, headers: true) do |student|
        next unless student['Regn No']

        school_class = SchoolClass.where(academic_year: student['Year'],
                                         name: student['Class'],
                                         year: student['Class'].split('.').first).first_or_create do |a_class|
          a_class.form_teacher = User.first
        end

        full_name = split_name(student['Name'])
        nric = student['NRIC'].strip.upcase
        admission_no = student['Regn No']

        new_student = Student.where(nric: nric).first_or_initialize
        student_hash = {
          admission_year: admission_no&.gsub(/.+?(\/)/, '')&.strip&.to_i,
          admission_no: admission_no,
          surname: full_name[:last_name],
          given_name: full_name[:first_name],
          date_of_birth: format_birthdate(student['Birthdate'].strip),
          place_of_birth: 'Singapore',
          race: student['Race'],
          nric: nric,
          citizenship: format_citizenship(student['Nationality']),
          gender: format_gender(student['Sex'])
        }
        new_student.update_attributes(student_hash)
        new_student.save(validate: false)

        new_student.student_classes.create(school_class: school_class)
        new_student.past_education_records.create(school_name: student['Previous School'])

        %w[Father Mother].each do |role|
          next unless student["#{role} Name"]

          poc_full_name = split_parent_name(student["#{role} Name"])
          poc_details = {
            relationship: role,
            salutation: poc_full_name[:salutation],
            surname: poc_full_name[:last_name],
            given_name: poc_full_name[:first_name],
            home_number: student["#{role} Home Number"],
            handphone_number: student["#{role} Mobile Number"],
            office_number: student["#{role} Office Number"],
            id_number: student["#{role} NRIC"],
            address: student["#{role} Address"],
            postal_code: student["#{role} Postal Code"],
            occupation: student["#{role} Occupation"]
          }

          poc = new_student.point_of_contacts.where(relationship: role).first_or_initialize
          poc.update(poc_details)
        end

        if student['Guardian Name']
          poc_full_name = split_parent_name(student['Guardian Name'])
          poc_details = {
            relationship: student['Guardian Relationship'],
            salutation: poc_full_name[:salutation],
            surname: poc_full_name[:last_name],
            given_name: poc_full_name[:first_name],
            handphone_number: student['Guardian Mobile Number'],
            address: student['Guardian Address'],
            postal_code: student['Guardian Postal Code'],
            occupation: student['Guardian Occupation'],
            email: student['Guardian Email']
          }

          poc = new_student.point_of_contacts.where(relationship: student['Guardian Relationship']).first_or_initialize
          poc.update(poc_details)
        end
      end
    end
  end

  class << self
    private

    def format_birthdate(birthdate)
      return unless birthdate

      DateTime.strptime(birthdate, '%d-%b-%y').to_date
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
      return { last_name: '', first_name: '' } unless full_name

      name_array = full_name.split(' ')
      last_name = name_array.shift
      first_name = name_array.join(' ')

      { last_name: last_name, first_name: first_name }
    end

    def split_parent_name(full_name)
      return { salutation: '', last_name: '', first_name: '' } unless full_name

      name_array = full_name.split(' ')
      salutation = name_array.shift

      new_full_name = split_name(name_array.join(' '))
      new_full_name[:salutation] = salutation

      new_full_name
    end
  end
end