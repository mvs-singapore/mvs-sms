class Report
  include ActiveModel::Model

  attr_accessor :age, :gender, :nationality, :disability, :status, :financial_assistance, :referred_by

  def initialize(params={})
    [:age, :gender, :nationality, :disability, :status, :financial_assistance, :referred_by].each do |field|
      self.send(:"#{field}=", params[field])
    end
  end
end