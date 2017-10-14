class AddImageIdToStudents < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :image_id, :string
  end
end
