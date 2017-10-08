class ChangeRemarkCategoryToString < ActiveRecord::Migration[5.1]
  def change
    remove_column :remarks, :category, :integer
    add_column :remarks, :category, :string, null: false
  end
end
