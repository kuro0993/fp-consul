class Staff < ApplicationRecord
  has_many :staff_appoint_frame
  has_many :appoint

  before_save { email.downcase! }

  validates :first_name, :last_name, :first_name_kana, :last_name_kana,
                    presence: true,
                    length: { maximum: 50 }
  validates :email, presence: true, 
                    length: { maximum: 255 },
                    format: { with: Constants::VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6}
  has_secure_password

  def full_name
    "#{last_name} #{first_name}"
  end

  def full_name_kana
    "#{last_name_kana} #{first_name_kana}"
  end
end
