FactoryGirl.define do
  factory :user  do
    email 'user@email.com'
    password 'password1234'
    name 'user'
  end

  factory :yammy, parent: :user do
    email 'yammy@email.com'
    name 'yammy'
    association :role, factory: :teacher
  end

  factory :ernest, parent: :user do
    email 'ernest@email.com'
    name 'ernest'
    association :role, factory: :super_admin
  end
end
