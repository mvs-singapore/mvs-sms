class PointOfContact < ApplicationRecord
  validates :relationship, presence: { message: ": Parent/Guardian relationship is required" }
  belongs_to :student
  enum id_type: [:pink, :blue]

  def contact_full_name
    "#{salutation} #{given_name} #{surname}".strip
  end

end
