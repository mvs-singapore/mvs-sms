FactoryGirl.define do
  factory :past_education_record do
    school_name 'Northlight'
    from_date Date.new(1990,1,1)
    to_date Date.new(1995,1,1)
    highest_qualification true
    student
  end
end
