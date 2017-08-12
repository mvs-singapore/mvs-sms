# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.where(email: 'sms-admin@mvs.edu.sg').first_or_create! do |user|
  user.password = 'password1234'
  user.role = 'super_admin'
  user.name = 'Super Admin'

  puts "Default admin account created."
end

User.where(email: 'teacher@mvs.edu.sg').first_or_create! do |user|
  user.password = 'password1234'
  user.role = 'teacher'
  user.name = 'Some Teacher'

  puts "Default teacher account created."
end

puts "Done seeding."