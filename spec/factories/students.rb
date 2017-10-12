FactoryGirl.define do
  factory :student do
    admission_year 2016
    admission_no '16006/2016'
    registered_at Date.parse('09/09/2017')
    current_class 'Food & Beverage'
    status 'new_admission'
    referred_by 'association_of_persons_with_special_needs'
    referral_notes 'Mdm Referee'
    surname 'Lee'
    given_name 'Ali'
    date_of_birth Date.parse('09/09/1997')
    place_of_birth 'Singapore'
    race 'Chinese'
    nric 'S8888888D'
    citizenship 'Singaporean'
    gender 'female'
    sadeaf_client_reg_no '12345/234'
    medication_needed 'Antihistamines'
    allergies 'Peanuts'
  end
end
