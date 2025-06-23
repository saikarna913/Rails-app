class Patient < ApplicationRecord
  belongs_to :user
  validates :first_name, :last_name, :date_of_birth, :medical_record_number, presence: true
  validates :medical_record_number, length: { is: 10 }, uniqueness: true
   def full_name
    "#{first_name} #{last_name}".strip
   end
end
