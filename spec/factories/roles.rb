FactoryBot.define do
  factory :role  do
    name 'role'
    super_admin false
  end

  factory :teacher, parent: :role do
    name 'teacher'
  end

  factory :super_admin, parent: :role do
    name 'super_admin'
    super_admin true
  end
end
