FactoryGirl.define do
  factory :attendance do
    date "2017-12-24"
    attendance_status "MyString"
    reason "MyString"
    remark "MyString"
    student nil
    school_class nil
  end
end
