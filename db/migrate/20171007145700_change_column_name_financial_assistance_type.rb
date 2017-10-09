class ChangeColumnNameFinancialAssistanceType < ActiveRecord::Migration[5.1]
  def change
    rename_column :financial_assistance_records, :type, :assistance_type
  end
end
