class Report
  include ActiveModel::Model

  VALID_FIELDS = [:age, :gender, :citizenship, :disability, :status, :referred_by].freeze
  SEARCH_FIELD_MAPPING = {
    age: 'students.age',
    gender: 'students.gender',
    citizenship: 'students.citizenship',
    disability: 'student_disabilities.disability_id',
    status: 'students.status',
    referred_by: 'students.referred_by'
  }.freeze

  attr_accessor *VALID_FIELDS

  def initialize(params={})
    VALID_FIELDS.each do |field|
      self.send(:"#{field}=", params[field])
    end
  end

  def search_students
    query_params = { query: [], args: [], joins: [] }

    if compact_params[:age]
      compact_params[:age].each { |age| query_params[:args] += date_range_for_age(age).values }
      query_params[:query] << '( ' + compact_params[:age].map{ '(students.date_of_birth BETWEEN ? AND ?)' }.join(' OR ') + ' )'
    end

    if compact_params[:gender]
      query_params[:args] << compact_params[:gender].map{ |gender| Student.genders[gender.downcase] }
      query_params[:query] << '( students.gender IN (?) )'
    end

    [:citizenship, :status, :referred_by, :disability].each do |field|
      if compact_params[field]
        query_params[:args] << compact_params[field]
        query_params[:query] << "( #{SEARCH_FIELD_MAPPING[field]} IN (?) )"
        if field == :disability
          query_params[:joins] << 'INNER JOIN student_disabilities ON student_disabilities.student_id = students.id'
        end
      end
    end

    return [] if query_params[:query].empty?

    Student.find_by_sql(build_query(query_params))
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

  def build_query(query:, args:, joins:)
    query_string = 'SELECT DISTINCT students.* FROM students ' + joins.join(' ') + ' WHERE ' + query.join(' AND ')
    [query_string, *args]
  end
end