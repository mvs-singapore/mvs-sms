FactoryBot.define do
  factory :internship_record do
    student
    internship_company
    internship_supervisor
    from_date Date.new(2017,1,1)
    to_date Date.new(2017,3,1)
    comments 'Good boy'
  end
end
