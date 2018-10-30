# frozen_string_literal: true

class Report
  include ActiveModel::Model

  VALID_FIELDS = %i[age gender citizenship disability status referred_by].freeze
  SEARCH_FIELD_MAPPING = {
    age: 'students.age',
    gender: 'students.gender',
    citizenship: 'students.citizenship',
    disability: 'student_disabilities.disability_id',
    status: 'students.status',
    referred_by: 'students.referred_by'
  }.freeze

  attr_accessor *VALID_FIELDS

  def initialize(params = {})
    VALID_FIELDS.each do |field|
      send(:"#{field}=", params[field])
    end
  end

  def search_students
    @query_params = { query: [], args: [], joins: [] }

    compact_params.keys.each { |field| send(:"by_#{field}") }

    return [] if @query_params[:query].empty?

    Student.find_by_sql(build_query(@query_params))
  end

  private

  def by_age
    compact_params[:age].each { |age| @query_params[:args] += date_range_for_age(age).values }
    @query_params[:query] << '( ' + compact_params[:age].map { '(students.date_of_birth BETWEEN ? AND ?)' }.join(' OR ') + ' )'
  end

  def by_gender
    @query_params[:args] << compact_params[:gender].map { |gender| Student.genders[gender.downcase] }
    @query_params[:query] << '( students.gender IN (?) )'
  end

  def by_disability
    @query_params[:args] << compact_params[:disability]
    @query_params[:query] << "( student_disabilities.disability_id IN (?) )"
    @query_params[:joins] << 'INNER JOIN student_disabilities ON student_disabilities.student_id = students.id'
  end

  def method_missing(method, *args, &block)
    is_matched = method.to_s =~ /^by_([a-z_]+)$/ && %w[citizenship status referred_by].include?(Regexp.last_match[1])
    if is_matched
      @query_params[:args] << compact_params[Regexp.last_match[1].to_sym]
      @query_params[:query] << "( #{SEARCH_FIELD_MAPPING[Regexp.last_match[1].to_sym]} IN (?) )"
    else
      super
    end
  end

  def respond_to_missing?(method, include_private = false)
    method.to_s =~ /^by_([a-z_]+)$/ && %w[citizenship status referred_by].include?(Regexp.last_match[1]) || super
  end

  def date_range_for_age(age)
    today = Date.today
    ref_age = age.to_i.years

    { from: (today.beginning_of_year - ref_age), to: (today.end_of_year - ref_age) }
  end

  def compact_params
    @compact_params ||= VALID_FIELDS.each_with_object({}) do |item, memo|
      value = send(:"#{item}")
      memo[item] = value.reject(&:empty?) if value && value.length > 1
    end
  end

  def build_query(query:, args:, joins:)
    query_string = 'SELECT DISTINCT students.* FROM students ' + joins.join(' ') + ' WHERE ' + query.join(' AND ')
    [query_string, *args]
  end
end
