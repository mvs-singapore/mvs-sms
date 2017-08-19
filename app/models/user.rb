class User < ApplicationRecord
  belongs_to :role
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable :registerable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # enum role: {super_admin: 'super_admin', teacher: 'teacher', principal: 'principal', vice_principal: 'vice_principal', clerk: 'clerk', case_worker: 'case_worker' }

  validates :name, presence: true, length: { maximum: 255 }

  def self.generate_random_password
    SecureRandom.hex(5)
  end

  def self.roles
    Role.all
  end
end
