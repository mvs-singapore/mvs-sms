class AddTshirtSizeToStudents < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :tshirt_size, :integer
  end
end
