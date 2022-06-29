class Staff < ApplicationRecord
  has_many :staff_appoint_frame
  has_many :appoint

  validates :first_name, :last_name, :first_name_kana, :last_name_kana, presence: true
  validates :email, presence: true
  validates :password, presence: true, length: { in: 6..20 }

  def full_name
    "#{last_name} #{first_name}"
  end

  def full_name_kana
    "#{last_name_kana} #{first_name_kana}"
  end
end
