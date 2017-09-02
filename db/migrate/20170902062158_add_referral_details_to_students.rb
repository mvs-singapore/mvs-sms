class AddReferralDetailsToStudents < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :referred_by, :string, null: false
    add_column :students, :referral_notes, :text
  end
end
