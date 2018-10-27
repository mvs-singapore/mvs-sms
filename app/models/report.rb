class Report
  include ActiveModel::Model

  attr_accessor :age, :gender, :nationality, :disability, :status, :financial_assistance, :referred_by

  def initialize(params={})
    [:age, :gender, :nationality, :disability, :status, :financial_assistance, :referred_by].each do |field|
      self.send(:"#{field}=", params[field])
    end
  end

  def search_students
    search_query = []
    search_params = []

    if age && age.count > 1
      search_query << age.select{ |a| a.length > 0 }
                       .map do |age|
        today = Date.today
        ref_age = age.to_i.years

        search_params << (today.beginning_of_year - ref_age)
        search_params << (today.end_of_year - ref_age)

        '(students.date_of_birth BETWEEN ? AND ?)'
      end.join(' OR ')
    end

    if gender && gender.count > 1
      search_params << gender.select{ |a| a.length > 0 }.map{ |gender| Student.genders[gender.downcase] }
      search_query << '( students.gender IN (?) )'
    end

    if nationality && nationality.count > 1
      search_params << nationality.select{ |a| a.length > 0 }
      search_query << '( students.citizenship IN (?) )'
    end

    unless search_query.empty?
      query_string = 'SELECT * FROM students WHERE ' + search_query.join(' AND ')
      Student.find_by_sql([query_string, *search_params])
    else
      []
    end
  end
end