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

User.where(email: 'sms-admin@mvs.edu.sg').first_or_create! do |user|
  user.password = 'password1234'
  user.role = Role.find_by(name: 'super_admin')
  user.name = 'Super Admin'

  puts "Default admin account created."
end

User.where(email: 'teacher@mvs.edu.sg').first_or_create! do |user|
  user.password = 'password1234'
  user.role = Role.find_by(name: 'teacher')
  user.name = 'Some Teacher'

  puts "Default teacher account created."
end

puts "Seeding disabilities"
['Hearing Impaired', 'Intellectual', 'Autism', 'Visually Impaired', 'Mild Learning Disability'].each do |disability|
  Disability.where(title: disability).first_or_create!
end

puts "Seeding medical conditions"
['Schizophrenia', 'ASD', 'Allergies', 'Hyperactive', 'Epilepsy', "Down's Syndrome", 'ADHD', 'Schizophrenia'].each do |medical_condition|
  MedicalCondition.where(title: medical_condition).first_or_create!
end

if Rails.env.development?
  InternshipCompany.where(name: 'Harvard Hotel').first_or_create! do |internship_company|
    internship_company.address = '1, Merlion Avenue, Singapore'
    internship_company.postal_code = '123456'

    puts "Default internship company created."
  end
end

puts "Done seeding."