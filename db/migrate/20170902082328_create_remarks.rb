class CreateRemarks < ActiveRecord::Migration[5.1]
  def change
    create_table :remarks do |t|
      t.references :student, foreign_key: true
      t.references :user, foreign_key: true
      t.date :event_date, null: false
      t.integer :category, null: false, default: 0
      t.text :details

      t.timestamps
    end
  end
end
