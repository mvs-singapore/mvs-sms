class CreateAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :attachments do |t|
      t.string :type
      t.string :filename
      t.string :notes
      t.references :student, foreign_key: true

      t.timestamps
    end
  end
end
