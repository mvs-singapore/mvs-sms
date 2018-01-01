FactoryBot.define do
  factory :financial_assistance_record do
    student
    assistance_type 'Pocket Fund'
    year_obtained '2014'
    duration '2 Years'
  end
end
