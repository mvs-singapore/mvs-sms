class User < ApplicationRecord
  belongs_to :role
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable :registerable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true, length: { maximum: 255 }
  has_many :school_classes, foreign_key: 'form_teacher_id'
  has_many :remarks

  def self.generate_random_password
    SecureRandom.hex(5)
  end

  def self.roles
    Role.all
  end

  def self.teachers
    teacher_role = Role.find_by(name: 'teacher')
    User.where(role: teacher_role)
  end
end
