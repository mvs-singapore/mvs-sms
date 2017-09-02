class CreateDisabilities < ActiveRecord::Migration[5.1]
  def change
    create_table :disabilities do |t|
      t.string :title

      t.timestamps
    end
  end
end
