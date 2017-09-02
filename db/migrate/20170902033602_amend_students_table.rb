class AmendStudentsTable < ActiveRecord::Migration[5.1]
  def change
    remove_column :students, :student_class, :integer
    add_column :students, :current_class, :string

    rename_column :students, :regis_date, :registered_at

    change_column_null :students, :admission_year, false
    change_column_null :students, :registered_at, false

    remove_column :students, :current_level, :string
    add_column :students, :status, :string, default: 'new_admission', null: false, index: true
  end
end
