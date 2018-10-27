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

    if age && age.count > 1
      search_query << age.select{ |a| a.length > 0 }
                       .map do |age|
        today = Date.today
        ref_age = age.to_i.years

        "(students.date_of_birth BETWEEN '#{(today.beginning_of_year - ref_age)}' AND '#{(today.end_of_year - ref_age)}')"
      end.join(" OR ")
    end

    if gender && gender.count > 1
      search_query << gender.select{ |a| a.length > 0 }
                           .map do |gender|
        "(students.gender = #{Student.genders[gender.downcase]})"
      end.join(" OR ")
    end

    unless search_query.empty?
      Student.find_by_sql("SELECT * FROM students WHERE " + search_query.join(" AND "))
    else
      []
    end
  end
end