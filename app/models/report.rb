# frozen_string_literal: true

class Report
  include ActiveModel::Model

  VALID_FIELDS = %i[age gender citizenship disability status referred_by].freeze

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
    append_params(query: '( ' + compact_params[:age].map { '(students.date_of_birth BETWEEN ? AND ?)' }.join(' OR ') + ' )')
  end

  def by_gender
    append_params(query: '( students.gender IN (?) )',
                  arg: compact_params[:gender].map { |gender| Student.genders[gender.downcase] })
  end

  def by_disability
    append_params(query: '( student_disabilities.disability_id IN (?) )',
                  arg: compact_params[:disability],
                  joins: 'INNER JOIN student_disabilities ON student_disabilities.student_id = students.id' )
  end

  def method_missing(method, *args, &block)
    return super unless %i[by_citizenship by_status by_referred_by].include?(method)

    field = /^by_([a-z_]+)$/.match(method)[1].to_sym

    append_params(query: "( students.#{field} IN (?) )",
                  arg: compact_params[field])
  end

  def respond_to_missing?(method, include_private = false)
    method.to_s =~ /^by_([a-z_]+)$/ && %w[citizenship status referred_by].include?(Regexp.last_match[1]) || super
  end

  def date_range_for_age(age)
    today = Date.today
    ref_age = age.to_i.years

    { from: (today.beginning_of_year - ref_age), to: (today.end_of_year - ref_age) }
  end

  def append_params(query: nil, arg: nil, joins: nil)
    @query_params[:args] << arg if arg
    @query_params[:query] << query if query
    @query_params[:joins] << joins if joins
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
