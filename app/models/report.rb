class Report
  include ActiveModel::Model

  VALID_FIELDS = [:age, :gender, :citizenship, :disability, :status, :referred_by].freeze

  attr_accessor *VALID_FIELDS

  def initialize(params={})
    VALID_FIELDS.each do |field|
      self.send(:"#{field}=", params[field])
    end
  end

  def search_students
    search_query = []
    search_params = []
    search_join = []

    if compact_params[:disability]
      search_join << 'INNER JOIN student_disabilities ON student_disabilities.student_id = students.id'
      search_params << compact_params[:disability].map(&:to_i)
      search_query << '( student_disabilities.disability_id IN (?) )'
    end

    if compact_params[:age]
      compact_params[:age].each { |age| search_params += date_range_for_age(age).values }
      search_query << '( ' + compact_params[:age].map{ '(students.date_of_birth BETWEEN ? AND ?)' }.join(' OR ') + ' )'
    end

    if compact_params[:gender]
      search_params << compact_params[:gender].map{ |gender| Student.genders[gender.downcase] }
      search_query << '( students.gender IN (?) )'
    end

    [:citizenship, :status, :referred_by].each do |field|
      if compact_params[field]
        search_params << compact_params[field]
        search_query << "( students.#{field} IN (?) )"
      end
    end

    return [] if search_query.empty?

    query_string = 'SELECT DISTINCT students.* FROM students ' + search_join.join(' ') + ' WHERE ' + search_query.join(' AND ')
    Student.find_by_sql([query_string, *search_params])
  end

  private

  def date_range_for_age(age)
    today = Date.today
    ref_age = age.to_i.years

    {from: (today.beginning_of_year - ref_age), to: (today.end_of_year - ref_age)}
  end

  def compact_params
    @compact_params ||= VALID_FIELDS.reduce({}) do |memo, item|
      value = self.send(:"#{item}")
      memo[item] = value.select{ |a| a.length > 0 } if value && value.length > 1

      memo
    end
  end
end