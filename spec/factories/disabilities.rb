FactoryBot.define do
  factory :disability do
    title { ['Hearing Impaired', 'Intellectual', 'Autism', 'Visually Impaired', 'Mild Learning Disability'].sample }
  end
end