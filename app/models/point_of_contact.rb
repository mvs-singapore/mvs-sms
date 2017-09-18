class PointOfContact < ApplicationRecord
  belongs_to :student
  enum id_type: [:pink, :blue]
end
