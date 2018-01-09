# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

['super_admin', 'teacher', 'principal', 'vice_principal', 'clerk', 'case_worker'].each do |role_str|
  Role.where(name: role_str).first_or_create! do |role|
    role.super_admin = ['super_admin', 'principal'].include?(role_str)
  end
end

User.where(email: 'ernest@mvs.edu.sg').first_or_create! do |user|
  user.password = 'password1234'
  user.role = Role.find_by(name: 'super_admin')
  user.name = 'Ernest'

  puts "Default admin account created."
end

User.where(email: 'yammy@mvs.edu.sg').first_or_create! do |user|
  user.password = 'password1234'
  user.role = Role.find_by(name: 'teacher')
  user.name = 'Yammy'

  puts "Default teacher account created."
end

puts "Seeding disabilities"
['Hearing Impaired', 'Intellectual', 'Autism', 'Visually Impaired', 'Mild Learning Disability'].each do |disability|
  Disability.where(title: disability).first_or_create!
end

puts "Seeding medical conditions"
['Schizophrenia', 'ASD', 'Allergies', 'Hyperactive', 'Epilepsy', "Down's Syndrome", 'ADHD'].each do |medical_condition|
  MedicalCondition.where(title: medical_condition).first_or_create!
end

InternshipCompany.where(name: 'Harvard Hotel').first_or_create! do |internship_company|
  internship_company.address = '1, Merlion Avenue, Singapore'
  internship_company.postal_code = '123456'

  puts "Default internship company created."
end

puts "Seeding school classes"
['Class 1.1 Food & Beverage', 'Class 1.2 Housekeeping'].each do |class_name|
  SchoolClass.create(
    academic_year: Faker::Number.between(2016, 2017),
    name: class_name,
    year: '1',
    form_teacher_id: 2
    )
end

['Class 2.1 Food Preparation', 'Class 2.2 F&B Service'].each do |class_name|
  SchoolClass.create(
    academic_year: Faker::Number.between(2016, 2017),
    name: class_name,
    year: '2',
    form_teacher_id: 2
    )
end

puts "Seeding internship supervisors"
InternshipSupervisor.create(
  name: Faker::Name.name,
  email: Faker::Internet.free_email,
  contact_number: Faker::Number.number(8),
  internship_company_id: 1
)

puts "Seeding students"
30.times do
  student = Student.create({
    admission_year: Faker::Number.between(2014, 2017),
    admission_no: "12345/123",
    registered_at: Date.today,
    status: ['New Admission', 'Year 1', 'Year 2'].sample,
    referred_by: "Association of Persons with Special Needs",
    referral_notes: Faker::Name.name,
    surname: Faker::Name.last_name,
    given_name: Faker::Name.first_name,
    date_of_birth: Faker::Date.birthday(14, 18),
    place_of_birth: Faker::Address.country,
    race: Faker::Demographic.race,
    nric: "S9874563D",
    citizenship: Faker::Demographic.demonym,
    gender: ['female', 'male'].sample,
    sadeaf_client_reg_no: "45678/456",
    medication_needed: "Antihistamines",
    allergies: "Peanuts",
    tshirt_size: "M",
    image_id: Faker::LoremPixel.image("300x300", false, 'cats')
  })
  student.past_education_records.create(
    school_name: Faker::Educator.secondary_school,
    from_date: Faker::Date.backward(365),
    to_date: Date.today,
    qualification: ['PSLE', 'Certificate'].sample,
    highest_qualification: true
  )
  ['Mother', 'Father'].each do |relationship|
    student.point_of_contacts.create(
      surname: Faker::Name.last_name,
      given_name: Faker::Name.first_name,
      address: Faker::Address.street_address,
      postal_code: Faker::Address.postcode,
      race: Faker::Demographic.race,
      dialect: "Cantonese",
      languages_spoken: "English, Mandarin",
      id_number: "S9874563D",
      id_type: "pink",
      date_of_birth: Faker::Date.birthday(50, 60),
      place_of_birth: Faker::Address.country,
      nationality: Faker::Demographic.race,
      occupation: Faker::Job.title,
      home_number: Faker::Number.number(8),
      handphone_number: Faker::Number.number(8),
      office_number: Faker::Number.number(8),
      relationship: relationship
    )
  end
  student.student_medical_conditions.create(
    medical_condition_id: [1, 2, 3, 4, 5, 6, 7].sample
  )
  student.student_disabilities.create(
    disability_id: [1, 2, 3, 4, 5].sample
  )
  student.financial_assistance_records.create(
    assistance_type: "Pocket Fund",
    year_obtained: Faker::Number.between(2014, 2017),
    duration: "1 Year"
  )
  student.internship_records.create(
    internship_company_id: 1,
    internship_supervisor_id: 1,
    from_date: Faker::Date.backward(365),
    to_date: Date.today,
    comments: Faker::Lorem.paragraph(2)
  )
  student.remarks.create(
    event_date: Date.today,
    user_id: 1,
    details: Faker::Lorem.paragraph(2),
    category: ['Incident', 'New Admission', 'Promoted', 'Retained', 'Internship Notes'].sample
  )
  student.student_classes.create(
    school_class_id: [1, 2, 3, 4].sample
  )
end

puts "Done seeding."
