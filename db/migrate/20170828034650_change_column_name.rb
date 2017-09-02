	class ChangeColumnName < ActiveRecord::Migration[5.1]
  def change
  	rename_column :students, :class, :student_class
  end
end
